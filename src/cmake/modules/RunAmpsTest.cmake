#
# Run AMPS test
#
# Use find_package(MPI) in project to set the MPI variables

cmake_minimum_required(VERSION 3.14)

# Execute command with error check
# A rank of -1 is used for a sequential run that is run without mpiexec.
# all parameters passed in as reference
macro(pf_amps_exec_check cmd ranks args)

  set( ENV{PF_TEST} "yes" )
  if (${${ranks}} GREATER 0)
    # Separate potentially space delimited arguments in MPIEXEC_PREFLAGS and MPIEXEC_POSTFLAGS.
    separate_arguments(sep_MPIEXEC_PREFLAGS NATIVE_COMMAND ${MPIEXEC_PREFLAGS})
    separate_arguments(sep_MPIEXEC_POSTFLAGS NATIVE_COMMAND ${MPIEXEC_POSTFLAGS})
    set( full_command ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${${ranks}} ${sep_MPIEXEC_POSTFLAGS} ${sep_MPIEXEC_PREFLAGS} ${${cmd}} ${${args}} )
  else()
    set( full_command ./${${cmd}} ${${args}} )
  endif()

  # Note: This method of printing the command is only necessary because the
  # 'COMMAND_ECHO' parameter of execute_process is relatively new, introduced
  # around cmake-3.15, and we'd like to be compatible with older cmake versions.
  # See the cmake_minimum_required above.
  list(JOIN full_command " " cmd_str)
  message(STATUS "Executing: ${cmd_str}")
  execute_process (COMMAND ${full_command} RESULT_VARIABLE cmd_result OUTPUT_VARIABLE joined_stdout_stderr ERROR_VARIABLE joined_stdout_stderr)
  message(STATUS "Output:\n${joined_stdout_stderr}")
  if (cmd_result)
    message (FATAL_ERROR "Error (${cmd_result}) while running test.")
  endif()

  # If FAIL is present test fails
  string(FIND "${joined_stdout_stderr}" "FAIL" test)
  if (NOT ${test} EQUAL -1)
    message (FATAL_ERROR "Test Failed: output indicated FAIL")
  endif()

  # Test must say PASSED to pass
  string(FIND "${joined_stdout_stderr}" "PASSED" test)
  if (${test} LESS 0)
    message (FATAL_ERROR "Test Failed: output did not indicate PASSED")
  endif()

  string(FIND "${joined_stdout_stderr}" "Using Valgrind" test)
  if (NOT ${test} EQUAL -1)
    # Using valgrind
    string(FIND "${joined_stdout_stderr}" "ERROR SUMMARY: 0 errors" test)
    if (${test} LESS 0)
      message (FATAL_ERROR "Valgrind Errors Found")
    endif()
  endif()

endmacro()

# Clean a parflow directory
macro(pf_amps_test_clean)
  file(GLOB FILES *.pfb*)
  if (NOT FILES STREQUAL "")
    file(REMOVE ${FILES})
  endif()

  file(GLOB FILES default_single.out)
  if (NOT FILES STREQUAL "")
    file(REMOVE ${FILES})
  endif()
endmacro()

pf_amps_test_clean ()

list(APPEND CMD ${PARFLOW_TEST})

if (${PARFLOW_HAVE_MEMORYCHECK})
  SET(ENV{PARFLOW_MEMORYCHECK_COMMAND} ${PARFLOW_MEMORYCHECK_COMMAND})
  SET(ENV{PARFLOW_MEMORYCHECK_COMMAND_OPTIONS} ${PARFLOW_MEMORYCHECK_COMMAND_OPTIONS})
endif()

pf_amps_exec_check(CMD PARFLOW_RANKS PARFLOW_ARGS)

if (${PARFLOW_HAVE_MEMORYCHECK})
  UNSET(ENV{PARFLOW_MEMORYCHECK_COMMAND})
  UNSET(ENV{PARFLOW_MEMORYCHECK_COMMAND_OPTIONS})
endif()
