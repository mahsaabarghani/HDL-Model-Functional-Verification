# Functional Verification of HDL Models

Course project for verifying an SDRAM controller and its reference model with Verilog/SystemVerilog, ModelSim, stimulus generators, a golden model, functional coverage, a checker, and a scoreboard.

The Persian title of the course, `درستی‌سنجی مدل‌های HDL`, translates to **Functional Verification of HDL Models**.

## Project structure

The work is organized by project phase. The SDRAM RTL used throughout the work is kept separately as the reference design.

| Folder | Description |
| --- | --- |
| [`reference-design/`](reference-design/) | SDRAM controller, SDRAM model, top-level design, and the original testbench. |
| [`phase-1-system-understanding/`](phase-1-system-understanding/) | Analysis of the SDRAM system, its bus interface, timing, control signals, and verification scenarios. |
| [`phase-2-deterministic-stimulus/`](phase-2-deterministic-stimulus/) | Deterministic stimulus generation for directed scenarios and corner cases. |
| [`phase-3-random-stimulus/`](phase-3-random-stimulus/) | Random and semi-random stimulus generation for broader scenario exploration. |
| [`phase-4-golden-model-and-coverage/`](phase-4-golden-model-and-coverage/) | Golden model implementation, output comparison, and code coverage results. |
| [`phase-5-checker-and-scoreboard/`](phase-5-checker-and-scoreboard/) | Final verification environment with checker, scoreboard, golden model, stimuli, and simulation logs. |
| [`phase-6-functional-coverage/`](phase-6-functional-coverage/) | Additional functional coverage work for deterministic and random SDRAM scenarios. |

## Phase details

### Phase 1 - System understanding

This phase documents the SDRAM controller and the surrounding bus interface. It identifies the inputs, outputs, timing parameters, control signals, read/write behavior, and candidate verification scenarios.

- [Phase 1 report](phase-1-system-understanding/phase-1-report.pdf)

### Phase 2 - Deterministic stimulus generator

Directed tests are created for selected normal and corner-case behaviors, including read/write operations, reset during activity, boundary addresses, rapid operations, and idle intervals.

- [Stimulus generator](phase-2-deterministic-stimulus/deterministic-stimuli-generator.sv)
- [Simulation output](phase-2-deterministic-stimulus/deterministic-output.txt)
- [Phase 2 report](phase-2-deterministic-stimulus/phase-2-report.pdf)

### Phase 3 - Random stimulus generator

The directed environment is extended with random and semi-random addresses, data values, operation types, and reset scenarios to exercise a wider range of behaviors.

- [Random stimulus generator](phase-3-random-stimulus/random-stimuli-generator.sv)
- [Simulation output](phase-3-random-stimulus/random-stimuli-output.txt)
- [Phase 3 report](phase-3-random-stimulus/phase-3-report.pdf)

### Phase 4 - Golden model and coverage

A behavioral golden model is used as an independent reference for the SDRAM interface. The phase also records output comparisons and ModelSim coverage results.

- [Phase 4 report](phase-4-golden-model-and-coverage/phase-4-report.pdf)
- [Coverage report](phase-4-golden-model-and-coverage/coverage-report.txt)
- [Results comparison](phase-4-golden-model-and-coverage/results-comparison.txt)

### Phase 5 - Checker and scoreboard

The verification environment is completed by comparing the design under verification with the golden model and recording matching, mismatching, and not-ready transactions.

- [Checker](phase-5-checker-and-scoreboard/codes/checker.sv)
- [Scoreboard](phase-5-checker-and-scoreboard/codes/scoreboard.sv)
- [Golden model](phase-5-checker-and-scoreboard/codes/golden-model.sv)
- [Random stimulus generator](phase-5-checker-and-scoreboard/codes/random-stimuli-generator.sv)
- [Checker output](phase-5-checker-and-scoreboard/output/checker-output.txt)
- [Results comparison](phase-5-checker-and-scoreboard/output/results-comparison.txt)
- [Phase 5 report](phase-5-checker-and-scoreboard/phase-5-report.pdf)

### Phase 6 - Functional coverage

This supplementary phase adds functional coverage analysis for important SDRAM control and data scenarios, covering both deterministic and random stimulus. It also includes the corresponding reports and generators.

- [Deterministic stimulus generator](phase-6-functional-coverage/deterministic-stimulus-generator.sv)
- [Random stimulus generator](phase-6-functional-coverage/random-stimuli-generator.sv)
- [Phase 6 report](phase-6-functional-coverage/phase-6-report.pdf)

## Reference documents

- [Project description](docs/project-description.pdf)
- [Functional coverage assignment](docs/functional-coverage-assignment.pdf)

## Tools

The project files target Verilog/SystemVerilog simulation and were prepared for use with ModelSim. File names and folder names in this repository use English descriptions for easier navigation on GitHub.
