function fitresult = FitBKGpower(x, y, Upper_bound, Lower_bound, StartPoint)
%Gaussian fitting, three coefficients

[xData, yData] = prepareCurveData(x, y); % Set up fittype and options.
%%fitting function
ftexpploy = fittype('a0 * x.^(-a1) + a2','dependent','y','independent','x','coefficients',{'a0','a1','a2'});
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Upper = Upper_bound;
opts.Lower = Lower_bound;
opts.StartPoint = StartPoint;
%%opts.MaxIter = 10000;

fitresult = fit( xData, yData, ftexpploy, opts )

%%[fitresult, gof] = fit( xData, yData, ft, opts ); % Plot fit with data.
%%h = plot(fitresult, xData, yData); xlabel( '¦Â' ); ylabel( 'R' );
%%legend off; grid on;hold on
%%plot(fitresult.b1,fitresult.a1,'^','markersize',6)

end

