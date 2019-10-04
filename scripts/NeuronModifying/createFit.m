function [fitresult, gof] = createFit(M, V, D)
%CREATEFIT(M,V,D)
%  Create a fit.
%
%  Data for 'fit1' fit:
%      X Input : M
%      Y Input : V
%      Z Output: D
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 17-Sep-2017 16:10:34


%% Fit: 'fit1'.
[xData, yData, zData] = prepareSurfaceData( M, V, D );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );

% Plot fit with data.
figure( 'Name', 'fit1' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'fit1', 'D vs. M, V', 'Location', 'NorthEast' );
% Label axes
xlabel M
ylabel V
zlabel D
grid on
view( -43.0, 42.4 );

