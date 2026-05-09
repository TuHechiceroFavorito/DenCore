# DENCORE - Basic CPU
I made this simple 8-bit CPU for fun, and to learn a bit better how CPUs work. I do have some prior knowledge of the basics of computation, but I have never built or studyied the full architecture of a CPU. I did all these from first principles and trial and error. The design is not perfect, but the main goal of the project, which was greatly accomplished

## Architecture
The diagrams of the design can be found under the folder Documentation. This is the full architecture.
![alt text](https://github.com/TuHechiceroFavorito/DenCore/blob/main/Documentation/CU.svg)

## Instruction set
I designed the instruction set to have the basic operations required for computation. The current version comes from learning from inneffient previous iterations. The current set is not perfect but it does work.

## Assembler
I didn't write much binary myself to test my design. I quickly decided to write an assembler. This can be found in assembler.py. This allowed me to write programs more efficiently and test quicker.

## Final test
The CPU was tested by implementing an iterative numerical algorithm to find the root of 2 via fixed-point decimal representation.