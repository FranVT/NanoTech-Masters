# Directory to compare methodologies

## Definition of Patchy particles

### Using Fix-Rigid

#### Integration commands
- fix rigidBodies all rigid/nve/small molecule langevin temp_o temp_f damp seed

### Using Bonds

#### Integration commands
- fix VelVerlet all nve
- fix ThermoLng all langevin temp_o temp_f damp seed zero yes 

## Deformation protocol

### Shear using change box

- run shear_it post no every 1 &
- "if 'shearDirection <= maxTilt' then 'change_box all xy delta shear_rate remap units box'" &
- "if 'shearDirection >= maxTilt' then 'change_box all xy final retoreTilt units box'"

### Shear using fix deform

- fix shear all deform 1 xy erate shear_rate remap v flip yes

### Compute the temperature
- Using temp
- Using temp/deform

