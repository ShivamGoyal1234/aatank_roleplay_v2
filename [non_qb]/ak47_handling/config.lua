Config = {}
Config.Command = 'tablet'

--You can set admin in alternative ways-------------------
--Ace Permission
Config.AdminWithAce = true
--Or license
Config.AdminWithLicense = {
    ['license:8889d3bf38112195036853ba7c111c3feb86d0cb'] = true,
    ['license:1b40b44d3bb50452d05e06d3ab2c22204e1459c6'] = true,
}

Config.Tuning = {
    {
        category = 'general',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2Z"/><path d="m12 18-3.4-4 1.4-1.4 2 2 4-4L18 12Z"/></svg>]],
        fields = {
            { name = "fMass", type = "float", min = 800, max = 4000, step = 10, value = 1800, description = "Car weight in kilograms; heavier cars are harder to push." },
            { name = "fInitialDragCoeff", type = "float", min = 1.0, max = 20.0, step = 0.1, value = 9.5, description = "How much air slows the car down at speed." },
            { name = "fPercentSubmerged", type = "int", min = 10, max = 120, step = 1, value = 85, description = "How much underwater before the car starts to float or sink." },
            { name = "vecCentreOfMassOffset", type = "vector", step = 0.01, value = { x = 0.0, y = 0.0, z = -0.1 }, description = "Moves the car's balance point for handling tweaks." },
            { name = "vecInertiaMultiplier", type = "vector", step = 0.01, value = { x = 1.0, y = 1.1, z = 1.2 }, description = "Affects how much the car resists spinning or tipping." }
        }
    },
    {
        category = 'transmission',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><path d="M12.5 17a2.5 2.5 0 0 0 0-5h-5a2.5 2.5 0 0 1 0-5h9.5"/><path d="m16 7 4 4-4 4"/><path d="M8 17H4"/></svg>]],
        fields = {
            { name = "fDriveBiasFront", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.0, description = "Sets if the car is RWD (0), FWD (1), or AWD (0.5)." },
            { name = "nInitialDriveGears", type = "int", min = 1, max = 10, step = 1, value = 7, description = "How many gears the car has." },
            { name = "fInitialDriveForce", type = "float", min = 0.05, max = 1.0, step = 0.01, value = 0.34, description = "Engine strength; higher = more acceleration." },
            { name = "fDriveInertia", type = "float", min = 0.1, max = 2.0, step = 0.01, value = 1.0, description = "How fast the engine revs up and down." },
            { name = "fClutchChangeRateScaleUpShift", type = "float", min = 0.1, max = 10.0, step = 0.1, value = 3.0, description = "Speed of upshifts (higher = faster gear changes)." },
            { name = "fClutchChangeRateScaleDownShift", type = "float", min = 0.1, max = 10.0, step = 0.1, value = 3.0, description = "Speed of downshifts (higher = faster gear changes)." },
            { name = "fInitialDriveMaxFlatVel", type = "float", min = 50, max = 800, step = 1, value = 160.0, description = "Estimated car top speed in km/h." }
        }
    },
    {
        category = 'brakes',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2Z"/><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z"/><path d="M12 12v6"/><path d="m16 16-2-2"/></svg>]],
        fields = {
            { name = "fBrakeForce", type = "float", min = 0.1, max = 5.0, step = 0.01, value = 1.35, description = "Strength of the brakes for stopping the car." },
            { name = "fBrakeBiasFront", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.55, description = "More value means more braking on front wheels." },
            { name = "fHandBrakeForce", type = "float", min = 0.1, max = 10.0, step = 0.1, value = 0.8, description = "Strength of the handbrake for drifting." }
        }
    },
    {
        category = 'traction',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><path d="M12 20a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z"/><path d="M12 14a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"/><path d="M12 2v2"/><path d="M12 22v-2"/><path d="m20 12-2 0"/><path d="m4 12 2 0"/><path d="m18.36 5.64-1.41 1.41"/><path d="m7.05 16.95-1.41 1.41"/><path d="m18.36 18.36-1.41-1.41"/><path d="m7.05 7.05-1.41-1.41"/></svg>]],
        fields = {
            { name = "fTractionCurveMax", type = "float", min = 0.5, max = 5.0, step = 0.01, value = 2.3, description = "Grip level when accelerating." },
            { name = "fTractionCurveMin", type = "float", min = 0.5, max = 5.0, step = 0.01, value = 2.1, description = "Grip level at low speed or braking." },
            { name = "fTractionCurveLateral", type = "float", min = 10.0, max = 30.0, step = 0.1, value = 18.5, description = "Grip while cornering." },
            { name = "fTractionSpringDeltaMax", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.15, description = "How much bumps and jumps affect grip." },
            { name = "fLowSpeedTractionLossMult", type = "float", min = 0.0, max = 5.0, step = 0.1, value = 1.0, description = "Loss of traction at low speeds (burnouts)." },
            { name = "fCamberStiffnesss", type = "float", min = -1.0, max = 1.0, step = 0.01, value = 0.0, description = "Grip change based on wheel tilt/drifting." },
            { name = "fTractionBiasFront", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.48, description = "Balance of grip front vs rear." },
            { name = "fTractionLossMult", type = "float", min = 0.0, max = 5.0, step = 0.01, value = 1.0, description = "Overall tendency to slide; higher is more sliding." }
        }
    },
    {
        category = 'suspension',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><path d="M12 5C8.68629 5 6 7.68629 6 11V18H18V11C18 7.68629 15.3137 5 12 5Z"/><path d="M6 18H3V15H6V18Z"/><path d="M18 18H21V15H18V18Z"/><path d="M10 2V5"/><path d="M14 2V5"/></svg>]],
        fields = {
            { name = "fSuspensionForce", type = "float", min = 0.1, max = 10.0, step = 0.01, value = 2.2, description = "Stiffness of the suspension; higher = stiffer." },
            { name = "fSuspensionCompDamp", type = "float", min = 0.1, max = 10.0, step = 0.01, value = 2.4, description = "Damping when wheels hit a bump." },
            { name = "fSuspensionReboundDamp", type = "float", min = 0.1, max = 10.0, step = 0.01, value = 3.4, description = "Damping when wheels return after a bump." },
            { name = "fSuspensionUpperLimit", type = "float", min = -0.5, max = 0.5, step = 0.01, value = 0.1, description = "How high wheels can move up from rest." },
            { name = "fSuspensionLowerLimit", type = "float", min = -0.5, max = 0.5, step = 0.01, value = -0.1, description = "How far wheels can drop from rest." },
            { name = "fSuspensionRaise", type = "float", min = -0.1, max = 0.1, step = 0.001, value = 0.0, description = "Visually raises or lowers the car." },
            { name = "fSuspensionBiasFront", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.5, description = "Stiffness front vs rear suspension." },
            { name = "fAntiRollBarForce", type = "float", min = 0.0, max = 5.0, step = 0.01, value = 0.3, description = "Prevents car from body rolling in corners." },
            { name = "fAntiRollBarBiasFront", type = "float", min = 0.0, max = 1.0, step = 0.01, value = 0.45, description = "Front/rear anti-roll bar balance." },
            { name = "fRollCentreHeightFront", type = "float", min = -1.0, max = 1.0, step = 0.01, value = 0.35, description = "Front anti-roll center height, affects rollovers." },
            { name = "fRollCentreHeightRear", type = "float", min = -1.0, max = 1.0, step = 0.01, value = 0.35, description = "Rear anti-roll center height, affects wheelies and rollovers." }
        }
    },
    {
        category = 'steering',
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 mr-3"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="3"></circle><line x1="12" y1="2" x2="12" y2="5"></line><line x1="12" y1="19" x2="12" y2="22"></line><line x1="2" y1="12" x2="5" y2="12"></line><line x1="19" y1="12" x2="22" y2="12"></line></svg>]],
        fields = {
            { name = "fSteeringLock", type = "float", min = 10, max = 90, step = 1, value = 35, description = "Max steering wheel angle in degrees." }
        }
    }
}


