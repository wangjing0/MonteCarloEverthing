figure;
subplot(1,2,1)
for i=1:n_t:nt
semilogy(grid,squeeze(T2_10(i,MAX,:)),'-'); hold on
%xlim([-100 1000])
ylim([0 0.1])

end
xlabel('\bfz (\mum)')
ylabel('\bfdT (K)')
hold off
legend(['10 \mum',', dt=',num2str(n_t*dt*1e3),'msec'])

subplot(1,2,2)
for i=1:n_t:nt
semilogy(grid,squeeze(T2_200(i,MAX,:)),'r-'); hold on
%xlim([-100 1000])
ylim([0 0.1])

end
hold off
legend(['200 \mum'])

colorbar_limit=[1e-5 1e-1];
figure;
subplot(1,2,1)
imagesc(grid,grid, log10(squeeze(T2_10(1,:,:))),log10(colorbar_limit)); 
 colorbar
xlabel('\bf z (\mum)')
ylabel('\bf x (\mum)')

subplot(1,2,2)
imagesc(grid,grid, log10(squeeze(T2_200(1,:,:))),log10(colorbar_limit)); 
 colorbar
xlabel('\bf z (\mum)')
ylabel('\bf x (\mum)')

title ({'\bf initial Temperature Distribution after 1msec 1mW stimulation (in Kevin)';})
