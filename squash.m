% Hayes Lee 20621556
% Justin Schaper 20634363
% Jeffrey Wang 20617964
% Jessie Won 20608181
% SYDE 411 - Project

% Inputs
% theta_v - hit angle in xz plane (deg)
% theta_h - hit angle in xy plane (deg)

% Outputs
% result - time it takes to get to ball(s)

% Vars
% robotX - x position of robot (m)
% robotY - y position of robot (m)
% opponentX - x position of opponent (m) (0 - 9.75)
% opponentY - y position of opponent (m) (0 - 6.4)

function [ result ] = squash(angles)
    % For now, 5 <= vertical hit angle <= 89, -60 <= horizontal <= 60
    hitZ = 0.482; % m
    runningSpeed = 6; % m/s
    hitVelocity = 40.0; % m/s
    robotX = 9.25; % m
    robotY = 3.2; % m
    opponentX = 8.75; % m
    opponentY = 1; % m
    cor = 0.434; % coeficcient of restitution

    hitVZ = hitVelocity * sind(angles(1));
    tHitGround = max(roots([4.905 -hitVZ hitZ]));
    if isreal(tHitGround) == 0
        result = 100000;
        return
    end
    reboundVelocity = hitVelocity * cor;
    
    % Calculate d2y including elasticity and one wall bounce
    if angles(2) >= 9.32
        tHitSideWall = (6.4 - robotY) / (hitVelocity * cosd(angles(1)) * sind(angles(2)));
        d2y = 6.4 + reboundVelocity * cosd(angles(1)) * sind(angles(2)) * (tHitGround - tHitSideWall);
    elseif angles(2) < -9.32
        tHitSideWall = (robotY) / (hitVelocity * cosd(angles(1)) * sind(angles(2)));
        d2y = 0 - (reboundVelocity * cosd(angles(1)) * sind(angles(2)) * (tHitGround - tHitSideWall));
    else
        d2y = robotY + hitVelocity * cosd(angles(1)) * sind(angles(2)) * tHitGround;
    end
    
    if d2y < 0
        d2y = -d2y;
    elseif d2y > 6.4
        d2y = 6.4 - (d2y - 6.4);
    end
    
    if d2y < 0
        d2y = 0;
    elseif d2y > 6.4
        d2y = 6.4;
    end

    % Calculate d2y including elasticity and one wall bounce
    tHitFrontWall = robotX / (hitVelocity * cosd(angles(1)) * cosd(angles(2)));
    d2x = reboundVelocity * cosd(angles(1)) * cosd(angles(2)) * (tHitGround - tHitFrontWall);
    if d2x > 9.75
        d2x = 9.75;
    end
        
    dOpponentFromBall = sqrt((d2x - opponentX).^2 + (d2y - opponentY).^2);
    
    % Result is the time it takes for the opponent to get to the ball after
    % it lands (s)
    result = -((dOpponentFromBall / runningSpeed) - tHitGround);
    playerTime = (dOpponentFromBall / runningSpeed);
    timeDiff = playerTime - tHitGround;
    
    
    disp(["ballx: " d2x]);
    disp(["bally: " d2y]);
    disp(["player time: " playerTime]);
    disp(["ball time: " tHitGround]);
    disp(["time diff: " timeDiff]);
    disp(["thetaV " angles(1)]);
    disp(["thetaH " angles(2)]);
end
