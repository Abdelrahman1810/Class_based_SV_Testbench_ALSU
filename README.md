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

## Getting Started
To get started with this repository, follow these steps:
> [!IMPORTANT]
> You need to download [QuestaSim](https://support.sw.siemens.com/en-US/) first.

1. Clone the repository to your local machine using the following command:
```ruby
git clone https://github.com/Abdelrahman1810/Class_based_SV_Testbench__ALSU.git
```
2. Open QuestaSim and navigate to the directory where the repository is cloned.
3. Compile the Verilog files by executing the following command in the QuestaSim transcript tap: 
```ruby
do run.do
```
This will compile All files in Codes folder.


## Class-based SystemVerilog Testbench

The testbench for the ALSU design is implemented using a class-based approach in SystemVerilog. This approach provides the following benefits:

1. **Reusability**: The testbench classes can be easily reused for other design verification tasks, promoting code reuse and reducing development time.
2. **Modularity**: The testbench is organized into separate classes, each responsible for a specific task, such as stimulus generation, response checking, and coverage collection. This modular design makes the testbench easier to maintain and extend.
3. **Scalability**: The class-based approach allows the testbench to scale easily as the design complexity increases, without compromising its structure or functionality.
4. **Testability**: The class-based testbench includes built-in self-checking mechanisms and coverage collection, making it easier to assess the completeness and quality of the verification process.

By using a class-based approach, the testbench for the ALSU design ensures modularity, reusability, and scalability, making it easier to maintain and extend the verification process over time.

## Contributing
If you find any issues or have suggestions for improvement, feel free to submit a pull request or open an issue in the repository. Contributions are always welcome!

## Contact info 💜

<a href="http://wa.me/201061075354" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/whatsapp-128C7E.svg?style=for-the-badge&logo=whatsapp&logoColor=white" /></a> 

<a href="https://www.linkedin.com/in/abdelrahman-mohammed-814a9022a/" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/linkedin-0077b5.svg?style=for-the-badge&logo=linkedin&logoColor=white" /></a>

Gmail : abdelrahmansalby23@gmail.com 📫

### this project from Eng.Kareem Waseem diploma
  <tbody>
    <tr>
      <td align="left" valign="top" width="14.28%">
      <a href="https://www.linkedin.com/in/kareem-waseem/"><img src="https://media.licdn.com/dms/image/C5603AQGwfgJJNpo8MQ/profile-displayphoto-shrink_800_800/0/1549202493548?e=1721865600&v=beta&t=9azKJacf-SZ18LX4UHwEa4gYKDCTIqLEwEDFWIu19Ko" width="100px;" alt="Kareem Waseem"/><br /><sub><b>Kareem Waseem</b></sub></a>
      <br /><a href="kwaseem94@gmail.com" title="Gmail">📧</a> 
      <a href="https://www.linkedin.com/in/kareem-waseem/" title="LinkedIn">🌍</a>
      <a href="https://linktr.ee/kareemw" title="Talks">📢</a>
      <a href="https://www.facebook.com/groups/319864175836046" title="Facebook grp">💻</a>
      </td>
    </tr>
  </tbody>
