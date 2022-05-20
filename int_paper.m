grid=(-MAX+0.5: 1: MAX-0.5)*mesh;
Io2_200=squeeze(mean(Io200(MAX:MAX+1,:,:),1));
Io2=200*Io2_200/max(max(Io2_200));
contourf(grid,grid,Io2,[0.35 1 2 5 10 100]);
colormap hot
colorbar