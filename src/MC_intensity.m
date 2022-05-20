%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Monte Carlo Simulation of light intensity
% by Jing Wang, (v.1.6-Matlab, 64bit system ) Jan. 2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t]=MC_intensity()
%% Parameters

photons=1e6; % number of launching photons
mu_a = 0.00007;%Absorption Coefficient in 1/um !!non-zero!!
mu_s=0.010;     % Scattering Coefficient in 1/um
g=0.88;        %anisotropic factor
mfp=1.0/(mu_a + mu_s); %mean free path in um
mesh= mfp/10; % mesh size in um
Maxsize= 10*mfp;  % ROI dimensions
MAX = Maxsize/mesh; %  max grid dimension, interger


power= 1; % power= 1mW
spot_size=200; % in um
NA=0.2;% numerical aperture
n_re=1.36; %index of refraction
theta0=asin(NA/n_re); % half divergent angle,generate launching direction, half of divergent angle in rad


ro=spot_size/2;
io=power*1e6/(pi*ro*ro); % peak intensity, in mW/mm^2, assum emission distribution is gaussian 

rho= 1.07*1e-3; % density of brain tissue in g/mm3
c=3.6; % specific heat, J/(gK)
power_= 1e-3; % power= 1mW in w
t_=1e-3; % stimulation time= 1msec
to=t_*power_/(rho*c*photons*1e-9*mesh*mesh*mesh); % coefficient, in K

Maxstep=100; % number of max scattering steps


%% trajectory and intensity recording

rand('twister', sum(100*clock)); % initialize the random number generator, system time as seed, "rand" uniformly distribute between(0,1)

tic

    X(Maxstep,photons,3)=0; %position vector(x,y,z) of each photon at each scattering position
  %initial position vector(x,y,z) in um
      phi=2*pi*rand(size(X(1,:,1)));
      r=(ro)*sqrt(rand(size(X(1,:,1)))); % % uniform light spot
    %  r=(ro)*sqrt(-log(rand(size(X(1,:,1))))); % % gaussian spot
      X(1,:,1) = r.*cos(phi); 
      X(1,:,2) = r.*sin(phi);
     % X(1,:,3)=(rand(size(X(1,:,3)))-1/2)*mesh;
      X(1,:,3)=0;
  
    L(Maxstep,photons) = 0; % travel length

     abs_=zeros(2*MAX,2*MAX,2*MAX); % probability of absorption
        
    psi= 2*pi*rand(photons,1);       % direction vector (u,v,w)
    w = cos(theta0*rand(photons,1));% uniformly divergent beam
    u = sqrt(1-w.*w).*cos(psi);          
    v = sqrt(1-w.*w).*sin(psi);
   
     
    for it=2:Maxstep
          
         s = (-mfp.*log(rand(photons,1)));% generate a step size from random number
         L(it,:)=L(it-1,:)+ s';  % total travel path length
         abs_weight=exp(-L(it-1,:)'*mu_a).*(mu_a/(mu_a+mu_s));
       % abs_weight=exp(-L(it-1,:)'*mu_a).*(1-exp(-s*mu_a));
         X(it,:,:)=squeeze(X(it-1,:,:))+ [s.*u s.*v s.*w]; % move a step, record position
        
         inds=squeeze(ceil(X(it,:,:)./mesh)+MAX); %indices of spatial location
         in_ROI=find(not(sum((inds<1 | inds>2*MAX),2)));% indices of photon within ROI
        
         for n=1:length(in_ROI)
             in=in_ROI(n); % index of photon
             abs_(inds(in,1),inds(in,2),inds(in,3))= abs_(inds(in,1),inds(in,2),inds(in,3))+ abs_weight(in);
         end
         
            psi = 2*pi*rand(photons,1);  % generate new direction
		    cosp = cos(psi);
		    sinp = sin(psi);
		    %cost = CTheta(g,photons);
            temp_ = (1-g*g)./(1-g+2.*g.*rand(photons,1));
            cost = (1+g*g - temp_.*temp_)/(2*g);
	        sint = sqrt(1.0 - cost.*cost);      

                     temp = sqrt(1.0 - w.*w);
                     temp_u =u;
                     temp_v =v;
                     temp_w =w;
                    u = sint.*(temp_u.*temp_w.*cosp - temp_v.*sinp)./temp + temp_u.*cost;
                    v = sint.*(temp_v.*temp_w.*cosp + temp_u.*sinp)./temp + temp_v.*cost;
                    w = -sint.*cosp.*temp + temp_w.*cost; 
                           
    end
 %To=to*abs_;
 %Io=io*abs_./max(max(max(abs_)));
 Io=io*abs_./abs_(MAX+1,MAX+1,MAX+1);
% 2D plot
    grid=(-MAX+0.5: 1: MAX-0.5)*mesh;
    Io2=squeeze(mean(Io(MAX:MAX+1,:,:),1)); %x-z plan profile
    int_plot(Io2,grid,[1e-5 1]); %  intensity plot

t=toc; % counting the caculation time 

assignin('base','mesh',mesh);
assignin('base','MAX',MAX);
assignin('base','Maxstep',Maxstep);
assignin('base','Io',Io);
%assignin('base','To',To);
%filename=strcat('MC_',num2str(power),'_',num2str(spot_size));
%save(filename, 'mesh','MAX','Maxstep','Io');

end
% %% costheta function
% function costheta = CTheta(g,n)
% end
% if(g ==0) 
%     costheta = 2*rand(n,1)-1;
% else 
%     temp = (1-g*g)./(1-g+2.*g.*rand(n,1));
%     costheta = (1+g*g - temp.*temp)/(2*g);
%  
% end
% end

