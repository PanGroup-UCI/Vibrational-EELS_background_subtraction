Package for background subtraction on ultrahigh energy resolution vibrational EEL spectra in Matlab.

The format of input data should be .dm3 or .dm4 for the spectra imaging datasets. The main code is 'VibEELS_BKG_DM_vxx.m'.

The code can align the vibrational spectra based on the ZLP center, and do the background subtraction. Then, you can map out the energy-filtered vibrational signal maps of different energy ranges. Finally, the code can save different key results and maps in .csv files and .jpg files.

You can choose four types of background fitting functions: (1) 'power0': power law, y = a0 * x.^(-a1) + a2; (2) 'power': power law zero, y = a0 * x.^(-a1); (3) 'Voigt': Voigt, y = g * exp(a4 * x.^4 - a2 * x.^2) + h / (w2 + x.^2) + c0; (4) 'exppoly': exponential polynomial, y = a0 *exp(- a1 * x + a2 * x.^2 - a3 * x .^3) + a5.

The published paper can be found (and cited) at: xxx, Available at http://

This work was supported by the Department of Energy (DOE), Office of Basic Energy Sciences, Division of Materials Sciences and Engineering under Grant DE-SC0014430. The authors acknowledge the use of facilities and instrumentation at the UC Irvine Materials Research Institute (IMRI), which is supported in part by the National Science Foundation through the UC Irvine Materials Research Science and Engineering Center (DMR-2011967).
