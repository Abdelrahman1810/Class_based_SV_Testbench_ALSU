# Class-based SystemVerilog Testbench for an ALSU

## Project Structure

The project contains the following components:

1. **Documentation**:
   - `verification_plan_flow.pdf`: Verification plan and flow
   - `code_brief.pdf`: Brief description of all the codes
   - `QuestaSim_snippets.pdf`: Snippet for QuestaSim
   - `cover_reports.pdf`: Cover reports

2. **Codes**:
   - **Design**:
     - `ALSU.v`: Design code
     - `ALSU_sva.sv`: SystemVerilog assertion for the design
   - **Golden Model**:
     - `ALSU_ref.sv`: Reference code
   - **Packages**:
     - `shared_pkg.sv`: Shared package
     - `coverage_pkg.sv`: Coverage package
     - `transaction_pkg.sv`: Transaction package
   - **Testbench**:
     - `testbench.sv`: Testbench code

3. **Reports**:
   - **HTML Reports**:
     - `index.html`: Code coverage HTML report
   - **Text Reports**:
     - `cover_alsu.txt`: Code coverage text report
     - `FUNCTION_COVER_ALSU.txt`: Function coverage text report

4. **Design Documentation**:
   - `ALSU_description.pdf`: PDF design description

## Class-based SystemVerilog Testbench

The testbench for the ALSU design is implemented using a class-based approach in SystemVerilog. This approach provides the following benefits:

1. **Reusability**: The testbench classes can be easily reused for other design verification tasks, promoting code reuse and reducing development time.
2. **Modularity**: The testbench is organized into separate classes, each responsible for a specific task, such as stimulus generation, response checking, and coverage collection. This modular design makes the testbench easier to maintain and extend.
3. **Scalability**: The class-based approach allows the testbench to scale easily as the design complexity increases, without compromising its structure or functionality.
4. **Testability**: The class-based testbench includes built-in self-checking mechanisms and coverage collection, making it easier to assess the completeness and quality of the verification process.

By using a class-based approach, the testbench for the ALSU design ensures modularity, reusability, and scalability, making it easier to maintain and extend the verification process over time.