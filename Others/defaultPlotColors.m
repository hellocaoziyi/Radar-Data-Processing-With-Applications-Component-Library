function out = defaultPlotColors(k)
%
% getDefaultPlotColors returns default colors for plot function.
% Every run of plot() function proceed by one row in the color array.
%
%  colors = defaultPlotColors()
%
%  colors = defaultPlotColors(k)
%
%  colors = defaultPlotColors('plot')
%
%
% INPUT ARGUMENTS
%  k        If k is a scalar positive integer, you can get k th color of
%           default colors. If k is a vector of such integers,
%           defaultPlotColors returs n by 3 array of default colors, where
%           n is the length of vector k and colors are ordered in rows by
%           the vector k.
%
% 'plot'    You can see all the seven default colors
%
%
% OUTPUT ARGUMENTS
% out       1 by 3 vector represents a MATLAB color, or n by 3 array of
%           n colors
%
%
% EXAMPLES
%
% defaultPlotColors()
%
% defaultPlotColors(3)
%
% defaultPlotColors(1:14)
%
% defaultPlotColors('plot')
%
%
% See also
% plotColors
%
% ColorOrderIndex (Axes property)
% http://uk.mathworks.com/help/matlab/graphics_transition/why-are-plot-lines-different-colors.html
%
% Written by Kouichi C. Nakamura Ph.D.
% MRC Brain Network Dynamics Unit
% University of Oxford
% kouichi.c.nakamura@gmail.com
% 10-Jul-2016 07:09:15


if verLessThan('matlab','8.4.0')
    
    colors = [0         0    1.0000;...
        0    0.5000         0;...
        1.0000         0         0;...
        0    0.7500    0.7500;...
        0.7500         0    0.7500;...
        0.7500    0.7500         0;...
        0.2500    0.2500    0.2500];
else
    colors = [0    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250;...
        0.4940    0.1840    0.5560;...
        0.4660    0.6740    0.1880;...
        0.3010    0.7450    0.9330;...
        0.6350    0.0780    0.1840];
end


if nargin == 0
    out = colors;
else
    if isscalar(k)
        
        i = mod(k, 7);
        if i == 0
            out = colors(7,:);
        else
            out = colors(i,:);
        end
        
    else
        
        if ischar(k) && strcmpi(k,'plot')
            figure
            plot([1:7;1:7],[zeros(1,7);ones(1,7)],'LineWidth',50)
            set(gca,'YTick',[])
            title('defaultPlotColors')
            
        elseif isvector(k) && all(k > 0) && all(fix(k) == k)
            
            if iscolumn(k)
                k = k';
            end
            
            C = arrayfun(@(x) defaultPlotColors(x), k,'UniformOutput',false);
            out = vertcat(C{:});
            
        else
            error('K:defaultPlotColors:argin:invalid',...
                'Input must be either postive integers (scalar or vector) or string "plot"');
        end
    end
end