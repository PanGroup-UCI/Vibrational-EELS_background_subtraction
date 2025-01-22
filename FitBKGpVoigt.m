function fitresult = FitBKGpVoigt(x, y, Upper_bound, Lower_bound, StartPoint)
%Gaussian fitting

[xData, yData] = prepareCurveData(x, y); % Set up fittype and options.
%%fitting function
ftexpploy = fittype('g.*exp(a4*x.^4 - a2*x.^2) + h./(w2 + x.^2) + c0',...
    'dependent','y','independent','x','coefficients',{'g','a4','a2','h','w2','c0'});
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

