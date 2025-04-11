# Project

Description
----
This folder is dedicated to project and board specific files (top rtl design, main filelist, constraints, top simulation testbench). It is organized in 2 level of subfolders.
On the first level, there is one subfolder per project.
On the second level there is one subfolder per supported board. There is also one makefile source (.mk) which define:
- Internal parameters of the project according to the targetted board
- IP in `rtl` folder to be used
- Top module design
- Importation of board/project specific files (RTL sources, constraints)


Organization
----
- `<project0_name>/`
	- `<board0_name>.mk`
	- `<board1_name>.mk`
	- `<board0_name>/`
		- `constrs/`
		- `sim/`
		- `synth/`
	- `<board1_name>/`
		- `constrs/`
		- `sim/`
		- `synth/`
- `<project1_name>/`
	- `<board0_name>.mk`
	- `<board1_name>.mk`
	- `<board0_name>/`
		- `constrs/`
		- `sim/`
		- `synth/`
	- `<board1_name>/`
		- `constrs/`
		- `sim/`
		- `synth/`

Project parameters
----
- `TOP` : Top level of the RTL design (must be synthetizable)
- `PRE_SYNTH_CONSTRAINTS` : Constraints files to be used before `synthesis` step
- `POST_SYNTH_CONSTRAINTS` : Constraints files to be used after `synthesis` step
- `PRE_OPT_CONSTRAINTS` : Constraints files to be used before `opt_design` step
- `POST_OPT_CONSTRAINTS` : Constraints files to be used after `opt_design` step
- `PRE_PLACEMENT_CONSTRAINTS` : Constraints files to be used before `placement` step
- `POST_PLACEMENT_CONSTRAINTS` : Constraints files to be used after `placement` step
- `PRE_ROUTE_CONSTRAINTS` : Constraints files to be used before `route` step
- `POST_ROUTE_CONSTRAINTS` : Constraints files to be used after `placement` step
- `PRE_BITSTREAM_CONSTRAINTS` : Constraints files to be used before `bitstream generation` step
- `PROBES_CONSTRAINTS` : Constrained files to be use before `opt_design` step to generate debug probes
- `SYNTH_SRC`: Synthetizable RTL files
- `SIM_SRC`: RTL files used for simulation only

Importing and IP
----

```make
include rtl/<ip_name>/sources.mk
```

# Architecture

```mermaid
flowchart TD
    subgraph PS [Système de Traitement]
        ARM[ARM Cortex-A9]
        SW[Logiciel de Contrôle]
    end

    subgraph PL [Logique Programmable]
        subgraph "Chemin de Données"
            subgraph "Capture et Tamponnage"
                I2S[Dongle I2S]
                DMA1[Contrôleur DMA Capture]
                DDR1[DDR Mémoire]
            end

            subgraph "Traitement FFT"
                DMA2[Contrôleur DMA FFT]
                FFT[Module FFT]
                DMA3[Contrôleur DMA Sortie FFT]
                DDR2[DDR Buffer FFT]
            end

  
          subgraph "Affichage"
                DMA4[Contrôleur DMA Affichage]
                VGA[Module VGA]
                
            end
        end
    end

    %% Transferts dans le chemin de données
    I2S --> DMA1
    DMA1 --> DDR1
    DDR1 --> DMA2
    DMA2 --> FFT
    FFT --> DMA3
    DMA3 --> DDR2
    DDR2 --> DMA4
    DMA4 --> VGA

    
    IN[Signal de Entrée - Audio]
    OUT[Signal de Sortie - Video Analog]
    IN -.->I2S
    VGA -.-> OUT

    %% Liaisons de contrôle entre PS et PL
    ARM --> SW
    SW -.-> DMA1
    SW -.-> DMA2
    SW -.-> DMA3
    SW -.-> DMA4

```

```mermaid
flowchart LR
    H[Composant X]

    M[Composant Y]
    subgraph "DMA-DDR"
        
        J[DMA]
        K[DDR]
        L[DMA]
    end
    H -- "AXI-Stream 32bits" --> J
    K -- "AXI-MemoryMap 32bits" --> L
    J -- "AXI-MemoryMap 32bits" --> K
    L -- "AXI-Stream 32bits" --> M
```
