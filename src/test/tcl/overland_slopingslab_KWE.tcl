#  Testing overland flow
# Running a parking lot sloping slab pointed in 8 directions
# With a suite of overlandflow BC options

set tcl_precision 17

#
# Import the ParFlow TCL package
#
lappend auto_path $env(PARFLOW_DIR)/bin
package require parflow
namespace import Parflow::*

pfset FileVersion 4


pfset Process.Topology.P        [lindex $argv 0]
pfset Process.Topology.Q        [lindex $argv 1]
pfset Process.Topology.R        [lindex $argv 2]

#---------------------------------------------------------
# Computational Grid
#---------------------------------------------------------
pfset ComputationalGrid.Lower.X           0.0
pfset ComputationalGrid.Lower.Y           0.0
pfset ComputationalGrid.Lower.Z           0.0

pfset ComputationalGrid.NX                5
pfset ComputationalGrid.NY                5
pfset ComputationalGrid.NZ                1

pfset ComputationalGrid.DX	             10.0
pfset ComputationalGrid.DY               10.0
pfset ComputationalGrid.DZ	            .05

#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
pfset GeomInput.Names                 "domaininput"
pfset GeomInput.domaininput.GeomName  domain
pfset GeomInput.domaininput.InputType  Box

#---------------------------------------------------------
# Domain Geometry
#---------------------------------------------------------
pfset Geom.domain.Lower.X                        0.0
pfset Geom.domain.Lower.Y                        0.0
pfset Geom.domain.Lower.Z                        0.0

pfset Geom.domain.Upper.X                        50.0
pfset Geom.domain.Upper.Y                        50.0
pfset Geom.domain.Upper.Z                          0.05
pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"


#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------

pfset Geom.Perm.Names                 "domain"
pfset Geom.domain.Perm.Type            Constant
pfset Geom.domain.Perm.Value           0.0000001

pfset Perm.TensorType               TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  "domain"

pfset Geom.domain.Perm.TensorValX  1.0d0
pfset Geom.domain.Perm.TensorValY  1.0d0
pfset Geom.domain.Perm.TensorValZ  1.0d0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            Constant
pfset SpecificStorage.GeomNames       "domain"
pfset Geom.domain.SpecificStorage.Value 1.0e-4

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------

pfset Phase.Names "water"

pfset Phase.water.Density.Type	        Constant
pfset Phase.water.Density.Value	        1.0

pfset Phase.water.Viscosity.Type	Constant
pfset Phase.water.Viscosity.Value	1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------

pfset Contaminants.Names			""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------

pfset Geom.Retardation.GeomNames           ""

#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------

pfset Gravity				1.0

#-----------------------------------------------------------------------------
# Setup timing info
#-----------------------------------------------------------------------------

#
pfset TimingInfo.BaseUnit        0.05
pfset TimingInfo.StartCount      0
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime        1.0
pfset TimingInfo.DumpInterval    -2
pfset TimeStep.Type              Constant
pfset TimeStep.Value             0.05

#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------

pfset Geom.Porosity.GeomNames          "domain"

pfset Geom.domain.Porosity.Type          Constant
pfset Geom.domain.Porosity.Value         0.01

#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------

pfset Domain.GeomName domain

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type               VanGenuchten
pfset Phase.RelPerm.GeomNames          "domain"

pfset Geom.domain.RelPerm.Alpha         6.0
pfset Geom.domain.RelPerm.N             2.

#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type              VanGenuchten
pfset Phase.Saturation.GeomNames         "domain"

pfset Geom.domain.Saturation.Alpha        6.0
pfset Geom.domain.Saturation.N            2.
pfset Geom.domain.Saturation.SRes         0.2
pfset Geom.domain.Saturation.SSat         1.0

#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names                           ""

#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------
pfset Cycle.Names "constant rainrec"
pfset Cycle.constant.Names              "alltime"
pfset Cycle.constant.alltime.Length      1
pfset Cycle.constant.Repeat             -1

# rainfall and recession time periods are defined here
# rain for 1 hour, recession for 2 hours

pfset Cycle.rainrec.Names                 "rain rec"
pfset Cycle.rainrec.rain.Length           2
pfset Cycle.rainrec.rec.Length            300
pfset Cycle.rainrec.Repeat                -1

#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------
pfset BCPressure.PatchNames                   [pfget Geom.domain.Patches]

pfset Patch.x-lower.BCPressure.Type		      FluxConst
pfset Patch.x-lower.BCPressure.Cycle		      "constant"
pfset Patch.x-lower.BCPressure.alltime.Value	      0.0

pfset Patch.y-lower.BCPressure.Type		      FluxConst
pfset Patch.y-lower.BCPressure.Cycle		      "constant"
pfset Patch.y-lower.BCPressure.alltime.Value	      0.0

pfset Patch.z-lower.BCPressure.Type		      FluxConst
pfset Patch.z-lower.BCPressure.Cycle		      "constant"
pfset Patch.z-lower.BCPressure.alltime.Value	      0.0

pfset Patch.x-upper.BCPressure.Type		      FluxConst
pfset Patch.x-upper.BCPressure.Cycle		      "constant"
pfset Patch.x-upper.BCPressure.alltime.Value	      0.0

pfset Patch.y-upper.BCPressure.Type		      FluxConst
pfset Patch.y-upper.BCPressure.Cycle		      "constant"
pfset Patch.y-upper.BCPressure.alltime.Value	      0.0

## overland flow boundary condition with very heavy rainfall then slight ET
pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "rainrec"
pfset Patch.z-upper.BCPressure.rain.Value	      -0.01
pfset Patch.z-upper.BCPressure.rec.Value	      0.0000

#---------------------------------------------------------
# Mannings coefficient
#---------------------------------------------------------

pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "domain"
pfset Mannings.Geom.domain.Value 3.e-6


#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.water.Type                         Constant
pfset PhaseSources.water.GeomNames                    domain
pfset PhaseSources.water.Geom.domain.Value        0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution


#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

pfset Solver                                             Richards
pfset Solver.MaxIter                                     2500

pfset Solver.Nonlinear.MaxIter                           50
pfset Solver.Nonlinear.ResidualTol                       1e-9
pfset Solver.Nonlinear.EtaChoice                         EtaConstant
pfset Solver.Nonlinear.EtaValue                          0.01
pfset Solver.Nonlinear.UseJacobian                       False

pfset Solver.Nonlinear.DerivativeEpsilon                 1e-15
pfset Solver.Nonlinear.StepTol				 1e-20
pfset Solver.Nonlinear.Globalization                     LineSearch
pfset Solver.Linear.KrylovDimension                      20
pfset Solver.Linear.MaxRestart                           2

pfset Solver.Linear.Preconditioner                       PFMG
pfset Solver.PrintSubsurf				False
pfset  Solver.Drop                                      1E-20
pfset Solver.AbsTol                                     1E-10

pfset Solver.OverlandKinematic.Epsilon                 1E-5


pfset Solver.WriteSiloSubsurfData False
pfset Solver.WriteSiloPressure False
pfset Solver.WriteSiloSlopes False

pfset Solver.WriteSiloSaturation False
pfset Solver.WriteSiloConcentration False

#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

# set water table to be at the bottom of the domain, the top layer is initially dry
pfset ICPressure.Type                                   HydroStaticPatch
pfset ICPressure.GeomNames                              domain
pfset Geom.domain.ICPressure.Value                      -3.0

pfset Geom.domain.ICPressure.RefGeom                    domain
pfset Geom.domain.ICPressure.RefPatch                   z-upper

#-----------------------------------------------------------------------------
# Run and Unload the ParFlow output files
# Running all 8 direction combinations with the upwind formulation on and off (i.e. 16 total)
#-----------------------------------------------------------------------------
#set runcheck to 1 if you want to run the pass fail tests
set runcheck 1
set first 1
source pftest.tcl

###############################
# Looping over slop configurations
###############################
foreach xslope [list 0.01 -0.01] yslope [list 0.01 -0.01] name [list posxposy negxnegy] {
  puts "$xslope $yslope $name"
#set name negy

  #### Set the slopes
  pfset TopoSlopesX.Type "Constant"
  pfset TopoSlopesX.GeomNames "domain"
  pfset TopoSlopesX.Geom.domain.Value $xslope

  pfset TopoSlopesY.Type "Constant"
  pfset TopoSlopesY.GeomNames "domain"
  pfset TopoSlopesY.Geom.domain.Value $yslope

  #original approach from K&M AWR 2006
  pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
  pfset Solver.Nonlinear.UseJacobian          False
  pfset Solver.Linear.Preconditioner.PCMatrixType PFSymmetric


  set runname Slab.$name.OverlandModule
  puts "##########"
  if $first==1 {
    puts $runname
    set first 0
  } else {
    puts "Running $runname Jacobian True"
  }
  pfrun $runname
  pfundist $runname
  if $runcheck==1 {
    set passed 1
    foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
      if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
        set passed 0
      }
      if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
        set passed 0
      }
    }
    if $passed {
      puts "$runname : PASSED"
    } {
      puts "$runname : FAILED"
    }
  }

# turn on analytical jacobian and re-test
pfset Solver.Nonlinear.UseJacobian                       True
pfset Solver.Linear.Preconditioner.PCMatrixType PFSymmetric

set runname Slab.$name.OverlandModule
puts "##########"
puts "Running $runname Jacobian True"
pfrun $runname
pfundist $runname
if $runcheck==1 {
  set passed 1
  foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
    if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
      set passed 0
    }
    if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
      set passed 0
    }
  }
  if $passed {
    puts "$runname : PASSED"
  } {
    puts "$runname : FAILED"
  }
}

# turn on non-symmetric Preconditioner and re-test
pfset Solver.Linear.Preconditioner.PCMatrixType         FullJacobian

set runname Slab.$name.OverlandModule
puts "##########"
puts "Running $runname Jacobian True Nonsymmetric Preconditioner"
pfrun $runname
pfundist $runname
if $runcheck==1 {
  set passed 1
  foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
    if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
      set passed 0
    }
    if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
      set passed 0
    }
  }
  if $passed {
    puts "$runname : PASSED"
  } {
    puts "$runname : FAILED"
  }
}

# run with KWE upwinding
pfset Patch.z-upper.BCPressure.Type		      OverlandKinematic
pfset Solver.Nonlinear.UseJacobian                       False
pfset Solver.Linear.Preconditioner.PCMatrixType PFSymmetric

  set runname Slab.$name.OverlandKin
  puts "##########"
  puts "Running $runname"
  pfrun $runname
  pfundist $runname
  if $runcheck==1 {
    set passed 1
    foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
      if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
        set passed 0
      }
      if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
        set passed 0
      }
    }
    if $passed {
      puts "$runname : PASSED"
    } {
      puts "$runname  : FAILED"
    }
  }

  # run with KWE upwinding jacobian true
  pfset Patch.z-upper.BCPressure.Type		      OverlandKinematic
  pfset Solver.Nonlinear.UseJacobian                       True
  pfset Solver.Linear.Preconditioner.PCMatrixType PFSymmetric

    set runname Slab.$name.OverlandKin
    puts "##########"
    puts "Running $runname Jacobian True"
    pfrun $runname
    pfundist $runname
    if $runcheck==1 {
      set passed 1
      foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
        if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
          set passed 0
        }
        if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
          set passed 0
        }
      }
      if $passed {
        puts "$runname : PASSED"
      } {
        puts "$runname  : FAILED"
      }
    }

    # run with KWE upwinding jacobian true and nonsymmetric preconditioner
    pfset Patch.z-upper.BCPressure.Type		      OverlandKinematic
    pfset Solver.Nonlinear.UseJacobian                       True
    pfset Solver.Linear.Preconditioner.PCMatrixType FullJacobian

      set runname Slab.$name.OverlandKin
      puts "##########"
      puts "Running $runname Jacobian True Nonsymmetric Preconditioner"
      pfrun $runname
      pfundist $runname
      if $runcheck==1 {
        set passed 1
        foreach i "00000 00001 00002 00003 00004 00005 00006 00007 00008 00009 00010" {
          if ![pftestFile $runname.out.press.$i.pfb "Max difference in Pressure for timestep $i" $sig_digits] {
            set passed 0
          }
          if ![pftestFile  $runname.out.satur.$i.pfb "Max difference in Saturation for timestep $i" $sig_digits] {
            set passed 0
          }
        }
        if $passed {
          puts "$runname : PASSED"
        } {
          puts "$runname  : FAILED"
        }
      }
}
