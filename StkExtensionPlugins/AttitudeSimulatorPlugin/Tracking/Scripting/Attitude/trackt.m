function output = trackt(input)
%#inbounds
switch input.method   
    
   case 'compute'
        computeData = input.methodData;

        A      = computeData.A;
        P      = computeData.P;

        q       = computeData.q;
        wc      = computeData.wc;
        wcDot   = computeData.wcDot;
        z       = computeData.z;
        h       = computeData.h;
        mode    = computeData.mode;
        Gamma   = computeData.Gamma;
        kq      = computeData.kq;
        
        Iest    = computeData.Iest;
        
        
        
        q4 = q(4);
        qv = q(1:3,1);
        relAngVel = q(5:7,1);
        zDot = A*z+qv;
        nu = wc;
        nuCross = buildCross(nu);
        nuPlus = buildPlus(nu);
        wcDotPlus = buildPlus(wcDot);
        qvCross = buildCross(qv);

        Gpt = wcDotPlus+nuCross*nuPlus;
        Hpt = Gpt*Iest;
        
        f = -0.5*kq*qv-0.5*q4*P*zDot+0.5*qvCross*P*zDot+Hpt+nuCross*h;
        
        IestDot = -Gamma*Gpt'*relAngVel;
        
        if mode > 0
            output.Torque = f;
            output.hDot = zeros(3,1);
        else
            output.Torque = zeros(3,1);
            output.hDot = -f;
        end            
        output.zDot = zDot;
        output.IestDot = IestDot;
                
    case 'register'
        
       param0 = {  'ArgumentName','mode',...
                    'Type','Parameter',...
                    'Name','mode',...
                    'Source','gains.m',...                    
                    'ArgumentType','Input'};

       param1 = {  'ArgumentName','q',...
                    'Type','Attitude',...
                    'RefName','Body',...
                    'RefSource','Satellite/Reference',...                    
                    'Derivative','Yes',...                                        
                    'ArgumentType','Input'};

        param2 = {  'ArgumentName','Gamma',...
                    'Type','Parameter',...
                    'Name','Gamma',...
                    'Source','gains.m',...                    
                    'ArgumentType','Input'};

        param3 = {  'ArgumentName','A',...
                    'Type','Parameter',...
                    'Name', 'A',...
                    'Source','gains.m',...                    
                    'ArgumentType','Input'};
            
        param4 = {  'ArgumentName','P',...
                    'Type','Parameter',...
                    'Name', 'P',...
                    'Source','gains.m',...                    
                    'ArgumentType','Input'};

       param5 = {   'ArgumentName','wc',...
                    'Type','Vector',...
                    'RefType','Attitude',...
                    'Name', 'AngVelocity',...
                    'Source','Satellite/Reference',...                    
                    'ArgumentType','Input'};

       param6 = {   'ArgumentName','wcDot',...
                    'Type','Vector',...
                    'RefType','Attitude',...
                    'Name', 'AngAccel',...
                    'Source','Satellite/Reference',...                    
                    'ArgumentType','Input'};
            
        param7 = {  'ArgumentName','h',...
                    'Type','Integral',...
                    'Name','MomentumBias',...
                    'ArgumentType','Input'};

        param8 = {  'ArgumentName','z',...
                    'Type','Integral',...
                    'Name','z',...
                    'ArgumentType','Input'};
            
        param9 = {  'ArgumentName','hDot',...
                    'Type','Parameter',...
                    'Name','hDot',...
                    'BasicType','Vector',...
                    'IntegralName','MomentumBias',...
                    'InitialCondition','0.0 0.0 0.0',...
                    'ArgumentType','Output'};

       param10 = {  'ArgumentName','zDot',...
                    'Type','Parameter',...
                    'Name','zDot',...
                    'BasicType','Vector',...
                    'IntegralName','z',...
                    'InitialCondition','0.0 0.0 0.0',...
                    'ArgumentType','Output'};
 
       param11 = {  'ArgumentName','Torque',...
                    'Type','Parameter',...
                    'BasicType','Vector',...
                    'Name','Torque',...
                    'ArgumentType','Output'};
 
      param12 = {  'ArgumentName','kq',...
                    'Type','Parameter',...
                    'Source','gains.m',...
                    'Name','kq',...
                    'ArgumentType','Input'};
     
      param13 = {  'ArgumentName','Iest',...
                    'Type','Integral',...
                    'Name','Iest',...
                    'ArgumentType','Input'};
            
       param14 = {  'ArgumentName','IestDot',...
                    'Type','Parameter',...
                    'Name','IestDot',...
                    'BasicType','Matrix',...
                    'Size','6 1',...
                    'IntegralName','Iest',...
                    'InitialCondition','10000.0 0.0 0.0 15000.0 0.0 10000.0',...
                    'ArgumentType','Output'};

       output = {param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14};
    
    otherwise
       output = [];
end

