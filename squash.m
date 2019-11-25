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
% opponentX - x position of opponent (m)
% opponentY - y position of opponent (m)

function [ result ] = squash(theta_v, theta_h)
    % For now, 5 <= vertical hit angle <= 89, -60 <= horizontal <= 60
    hitZ = 0.482; % m
    runningSpeed = 3.71; % m/s
    hitVelocity = 40; % m/s
    robotX = 5; % m
    robotY = 5; % m
    opponentX = 6 ; % m
    opponentY = 2; % m

    hitVZ = hitVelocity * sind(theta_v);
    tHitGround = max(roots([4.905 -hitVZ hitZ]));
    d2x = hitVelocity * cosd(theta_v) * cosd(theta_h) * tHitGround - robotX;
    if theta_h <= 0
        d2y = robotY - hitVelocity * cosd(theta_v) * sind(theta_h) * tHitGround;
    else
        d2y = robotY + hitVelocity * cosd(theta_v) * sind(theta_h) * tHitGround;
    end
    dOpponentFromBall = sqrt((d2x - opponentX).^2 + (d2y - opponentY).^2);
    
    
    % Result is the time it takes for the opponent to get to the ball after
    % it lands (s)
    result = (dOpponentFromBall / runningSpeed) - tHitGround;
end
