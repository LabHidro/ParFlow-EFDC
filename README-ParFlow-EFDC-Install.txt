Installing ParFlow on Ubuntu LTS
Since we have been working with ParFlow on Ubuntu, we thought that it might be helpful to provide a guide for others to install ParFlow on Ubuntu systems. The following directions are to install the current version of ParFlow on the two most recent Ubuntu LTS releases, 18.04 and 20.04.

1) Setup development packages on Linux
First, you need to download the new package information and install some new packages. Copy and paste the following in your command line:

sudo apt-get install build-essential curl git gfortran libopenblas-dev liblapack-dev openssh-client openssh-server openmpi-bin libopenmpi-dev tcl-dev tk-dev 

2) Create the ParFlow directory and its components
Next, you need to create a directory for ParFlow with a few subfolders. This example installs ParFlow and all its dependencies in the home (~) folder, although you can change this to whatever you’d like.

   mkdir -p ~/parflow/build ~/parflow/dependencies/cmake ~/parflow/dependencies/hypre-src

3) Fetch the dependencies (cmake and hypre)
Let’s start with downloading cmake (3.19.0 being the current version):

   cd ~/parflow/dependencies/cmake 
   curl -L https://cmake.org/files/v3.19/cmake-3.19.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xzv 

Once that is completed, you can install hypre (2.19.0 being the current version):

   cd ~/parflow/dependencies/hypre-src 
   curl -L https://github.com/hypre-space/hypre/archive/v2.19.0.tar.gz | tar --strip-components=1 -xzv 
   cd src
 
   ./configure --prefix ~/parflow/dependencies/hypre --with-MPI --with-cuda=/usr/local/cuda
   make install 

4) Download and install SILO

 cd ~/parflow/dependencies/
 wget https://wci.llnl.gov/sites/wci/files/2021-01/silo-4.10.2.tgz
 chmod 777 silo-4.10.2.tgz
 tar -xvf silo-4.10.2.tgz
 mv silo-4.10.2 silo
 cd silo
 ./configure --disable-silex
 sudo make all install


5) Download and Install UCX and OpenMPI

 cd ~/parflow/dependencies/
 wget https://github.com/openucx/ucx/releases/download/v1.8.0-rc1/ucx-1.8.0.tar.gz
 chmod 777 ucx-1.8.0.tar.gz
 tar -xvf ucx-1.8.0.tar.gz
 cd ucx-1.8.0
 ./contrib/configure-release --prefix ~/parflow/dependencies/ucx-cuda --with-cuda=/usr/local/cuda --with-java=no --disable-numa
 sudo make -j8 install
 cd ..
 sudo rm -fr ucx-1.8.0 ucx-1.8.0.tar.gz


 cd ~/parflow/dependencies/
 wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.gz
 chmod 777 openmpi-4.0.3.tar.gz
 tar -xvf openmpi-4.0.3.tar.gz
 cd openmpi-4.0.3
 ./configure --prefix ~/parflow/dependencies/openmpi-cuda --with-cuda=/usr/local/cuda --with-ucx=/home/tomas/parflow/dependencies/ucx-cuda
 sudo make -j8 install 
 sudo ldconfig 
 cd ..
 sudo rm -fr openmpi-4.0.3 openmpi-4.0.3.tar.gz

Incluir nas variáveis de ambiente: 

export PATH=/home/tomas/parflow/dependencies/ucx-cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/home/tomas/parflow/dependencies/ucx-cuda/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH=/home/tomas/parflow/dependencies/ucx-cuda/lib/ucx${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

export PATH=/home/tomas/parflow/dependencies/openmpi-cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/home/tomas/parflow/dependencies/openmpi-cuda/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH=/home/tomas/parflow/dependencies/openmpi-cuda/lib/openmpi${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


6) Install RMM

export CUDA_HOME=:/usr/local/cuda_10.1
export CMAKE_DIR=:/home/labhidro/parflow/dependencies/cmake
export PATH=$CMAKE_DIR/bin:$PARFLOW_DIR/openmpi-cuda/bin:$PARFLOW_DIR/bin:$PATH
    

    cd ~/parflow/
    git clone -b branch-0.18 --single-branch --recurse-submodules https://github.com/rapidsai/rmm.git && \
    cd rmm && \
    ~/parflow/dependencies/cmake/bin/cmake . -D CMAKE_INSTALL_PREFIX=$PARFLOW_DIR && \
    make -j && \
    make install && \
    cd .. && \
    rm -fr rmm


5) Download and build ParFlow
You can then download ParFlow from GitHub using the commands below. The current release as of this post is v3.7.0. Note: Ubuntu 20.04 has a newer version of tcl that is not compatible with the current release. If you are installing ParFlow on Ubuntu 20.04, replace the “v3.7.0” with “master” to clone the master branch instead. The current master branch of ParFlow is compatible with the newer version of tcl on Ubuntu 20.04.

   git clone --single-branch --branch master --recursive https://github.com/parflow/parflow.git ~/parflow/src 

Enter the following in your command line to build ParFlow.

only MPI:

   ~/parflow/dependencies/cmake/bin/cmake -S ~/parflow/src -B ~/parflow/build -D PARFLOW_AMPS_LAYER=mpi1 -D PARFLOW_AMPS_SEQUENTIAL_IO=TRUE -D HYPRE_ROOT=~/parflow/dependencies/hypre -D SILO_ROOT=~/parflow/dependencies/silo -D PARFLOW_ENABLE_TIMING=TRUE -D PARFLOW_HAVE_CLM=TRUE -D PARFLOW_ACCELERATOR_BACKEND=none

Or with GPU + EFDC + NETCDF:

  ~/parflow/dependencies/cmake/bin/cmake -S ~/parflow/src -B ~/parflow/build -D CMAKE_C_FLAGS=-lcuda -D PARFLOW_AMPS_LAYER=mpi1 -D PARFLOW_AMPS_SEQUENTIAL_IO=TRUE -D HYPRE_ROOT=~/parflow/dependencies/hypre -D SILO_ROOT=~/parflow/dependencies/silo -D PARFLOW_ENABLE_TIMING=TRUE -D PARFLOW_HAVE_CLM=TRUE -D PARFLOW_ACCELERATOR_BACKEND=cuda -D PARFLOW_HAVE_EFDC=TRUE 

Use the following commands to enable NETCDF:

-D HDF5_ROOT=/usr/local/hdf5-1.12.0 -D NETCDF_DIR=/usr/local/netcdf-4.3.3.1 -D NETCDF_INCLUDE_DIR=/usr/local/netcdf-4.3.3.1/include


   ~/parflow/dependencies/cmake/bin/cmake --build ~/parflow/build

   ~/parflow/dependencies/cmake/bin/cmake --install ~/parflow/build --prefix ~/parflow/install

6) Create an environment file
Here, you will create an environment file “env.sh” to store the ParFlow directory, making it easier to reference ParFlow when you want to run it later. Type the following:

   echo export PARFLOW_DIR=~/parflow/install >> ~/parflow/env.sh 

With that environment file, you can use ParFlow from anywhere by sourcing it, as shown:

   source ~/parflow/env.sh

7) Test ParFlow
Here, you will create an environment file “env.sh” which points to the necessary directories for keeping the components necessary for running ParFlow. Enter the following:

Hopefully you haven’t gotten any errors at this point and you have installed ParFlow successfully. To test ParFlow, source the environment file above and then type:

   cd ~/parflow/build/ 
   ~/parflow/dependencies/cmake/bin/ctest -VV 

This will run the series of tests to make sure your install of ParFlow is working correctly. 



