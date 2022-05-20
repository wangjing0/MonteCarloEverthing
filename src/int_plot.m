% plot a 2D intensity profile and equ-intensity contour, in log10 scale
function []=int_plot(int,grid, colorbar_limit)

figure;
imagesc(grid,grid, int); colorbar
xlabel('\bf z (\mum)')
ylabel('\bf x (\mum)')
 title ('\bf Intensity Distribution (mW/mm^2)')
 
int=int/max(max(int)); % normalization

figure;imagesc(grid,grid, log10(int),log10(colorbar_limit)); 
 colorbar
xlabel('\bf z (\mum)')
ylabel('\bf x (\mum)')
 title ('\bf Intensity Distribution (in log10 scale)')
figure;
contourf(grid,grid,log10(int),log10([0.0001 0.001, 0.01 0.1 1]));
colormap hot 
colorbar

