# Winter Meeting 2025

## Stress analysis in a patchy-particle based hydrogel simulation


### Description of the model

#### Interaction between patches

```math
U_{\mathrm{WCA}}\left(r\right) = 4\epsilon\left[\left(\frac{\sigma}{r}\right)^{12} + \left(\frac{\sigma}{r}\right)^{6}\right] + \epsilon,\qquad r\in\left[0,2^{1/6}\right]
```

```math
U_{\mathrm{patchy}}\left(r_{\mu\upsilon}\right) = 2\epsilon_{\mu\upsilon}\left(\frac{\sigma^{4}_{p}}{2 r^{4}_{\mu\upsilon}}-1\right)\exp\left[\frac{\sigma_p}{\left(r_{\mu\upsilon}-r_c\right)}+2\right],\quad r_{\mu\upsilon}\in\left[0,r_c\right]
```

```math
\begin{align*}
    U_{\mathrm{swap}}\left(r\right) &= w\sum_{\lambda,\mu,upsilon}\epsilon_{\mu\epsilon}U_3\left(r_{\lambda,\mu}\right)U_3\left(r_{\lambda,\upsilon}\right),\quad r_{\mu\upsilon}\in\left[0,r_c\right] \\
    U_3\left(r\right) &= -\frac{U_{\mathrm{patchy}}\left(r\right)}{\epsilon_{\mu\epsilon}},\quad r_{\mu\epsilon}\in\left[0,r_c\right]
\end{align*}
```

### Simulation protocols

|** Shear deformation **| ** Shear deformation **|
| ![shear1Gif](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/shear-II_animation.gif) | ![shear2Gif](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/shear-III_animation.gif) |
|** Deformation and relaxation ** | ** Relaxation and deformation **|
| ![shear-rlx1Gif](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/shear-relaxation_animation.gif) | ![shear-rlx2Gif](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/relaxation-shear_animation.gif) |


### Results


| ![Stress](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/figStress.png) | ![Yield Stress](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/figYieldStress.png) |
|----|----|
| ![Deformation](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/figDef.png) | ![Relaxation](https://github.com/FranVT/NanoTech-Masters/blob/main/Tesis/WinterMeeting2025/poster/figRlx.png) |

