Package for background subtraction on ultrahigh energy resolution vibrational EEL spectra in Matlab

The format of input data should be .dm3 or .dm4 for the spectra imaging datasets. 

You can choose four types of background fitting functions: (1) power law (y = a0 * x.^(-a1) + a2); (2) power law zero (y = a0 * x.^(-a1)); (3) Voigt (g.*exp(a4*x.^4 - a2*x.^2) + h./(w2 + x.^2) + c0'); (4) polynomial (a0*exp( - a1 * x + a2 * x.^2 - a3 * x .^3) + a5).

A detailed explanation of the theory behind PC (power cepstral) stain mapping analysis can be found in "The Exit-Wave Power-Cepstrum Transform for Scanning Nanobeam Electron Diffraction: Robust Strain Mapping at Subnanometer Resolution and Subpicometer Precision" at http://arxiv.org/abs/1911.00984

The published paper can be found (and cited) at: E. Padgett, M. E. Holtz, P. Cueva, Y. T. Shao, E. Langenberg, D. G. Schlom, and D. A. Muller. “The Exit-Wave Power-Cepstrum Transform for Scanning Nanobeam Electron Diffraction: Robust Strain Mapping at Subnanometer Resolution and Subpicometer Precision” Ultramicroscopy 214, (2020): 112994. doi:10.1016/j.ultramic.2020.112994, Available at http://www.sciencedirect.com/science/article/pii/S0304399119303377

This work was supported by the U.S. Department of Energy through the Center for Alkaline-based Energy Solutions, an Energy Frontier Research Center funded by the US Department of Energy, Office of Science, Basic Energy Sciences Award DE-SC0019445 (2019-2020). This work made use of electron microscopy facilities supported by the NSF MRSEC program (DMR-1719875) and an NSF MRI grant (DMR-1429155). The authors thank John Grazul, Malcolm Thomas, and Mariena Silvestry Ramos for assistance with electron microscopy facilities and sample preparation.
