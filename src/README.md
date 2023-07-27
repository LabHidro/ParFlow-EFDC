# ParFlow

![ParFlow CI Test](https://github.com/parflow/parflow/workflows/ParFlow%20CI%20Test/badge.svg)

ParFlow is an open-source, modular, parallel watershed flow model. It
includes fully-integrated overland flow, the ability to simulate
complex topography, geology and heterogeneity and coupled land-surface
processes including the land-energy budget, biogeochemistry and snow
(via CLM). It is multi-platform and runs with a common I/O structure
from laptop to supercomputer. ParFlow is the result of a long,
multi-institutional development history and is now a collaborative
effort between CSM, LLNL, UniBonn and UCB. ParFlow has been coupled to
the mesoscale, meteorological code ARPS and the NCAR code WRF.

For an overview of the major features and capabilities see the
following paper: [Simulating coupled surface–subsurface flows with
ParFlow v3.5.0: capabilities, applications, and ongoing development of
an open-source, massively parallel, integrated hydrologic
model](https://www.geosci-model-dev.net/13/1373/2020/gmd-13-1373-2020.pdf).

The Parflow User Manual is available at [Parflow Users
Manual](https://github.com/parflow/parflow/blob/master/parflow-manual.pdf).
The manual contains additional documentation on how to use ParFlow and
setup input files.  A quick start is included below.

### Citing Parflow

If you want the DOI for a specific release see:
[Zendo](https://zenodo.org/search?page=1&size=20&q=parflow&version)

A generic DOI that always links to the most current release :
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4816884.svg)](https://doi.org/10.5281/zenodo.4816884)

If you use ParFlow in a publication and wish to cite a paper reference
please use the following that describe model physics:

* Ashby S.F. and R.D. Falgout, Nuclear Science and Engineering 124:145-159, 1996
* Jones, J.E. and C.S. Woodward, Advances in Water Resources 24:763-774, 2001
* Kollet, S.J. and R.M. Maxwell, Advances in Water Resources 29:945-958, 2006
* Maxwell, R.M. Advances in Water Resources 53:109-117, 2013

If you use ParFlow coupled to CLM in a publication, please also cite
two additional papers that describe the coupled model physics:

* Maxwell, R.M. and N.L. Miller, Journal of Hydrometeorology 6(3):233-247, 2005
* Kollet, S.J. and R.M. Maxwell, Water Resources Research 44:W02402, 2008

### Additional Parflow resources

The ParFlow website has additional information on the project:
- [Parflow Web Site](https://parflow.org/)

You can join the Parflow Google Group/mailing list to communicate with
the Parflow developers and users.  In order to post you will have to
join the group, old posts are visible without joining:
- [Parflow-Users](https://groups.google.com/g/parflow)

A Parflow blog is available with notes from users on how to compile and use Parflow:
- [Parflow Blog](http://parflow.blogspot.com/)

To report Parflow bugs, please use the GitHub issue tracker for Parflow:
- [Parflow Issue Tracker](https://github.com/parflow/parflow/issues)


Parflow is released under the GNU General Public License version 2.1

For details and restrictions, please read the LICENSE.txt file.
- [LICENSE](./LICENSE.txt)
