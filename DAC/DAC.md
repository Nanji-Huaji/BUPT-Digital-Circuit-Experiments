# Entity: DAC_Controller 
- **File**: DAC.v

## Diagram
![Diagram](DAC_Controller.svg "Diagram")

## Ports

| Port name | Direction | Type  | Description    |
| --------- | --------- | ----- | -------------- |
| clk       | input     |       | 时钟信号       |
| rst       | input     |       | 复位信号       |
| dac_out   | output    | [7:0] | 8位DAC输出信号 |

## Signals

| Name              | Type      | Description  |
| ----------------- | --------- | ------------ |
| sine_wave [0:255] | reg [7:0] | 正弦波查找表 |
| index             | reg [7:0] | 查找表索引   |

## Processes
- unnamed: ( @(posedge clk or posedge rst) )
  - **Type:** always
  - **Description:** 在时钟上升沿或复位信号上升沿触发。复位时，将索引和输出信号重置为0。否则，从查找表中读取正弦波值并输出，同时索引递增。

## Description
`DAC_Controller`模块用于控制8位DAC芯片（如DAC0808）输出正弦波信号。模块内部使用一个查找表存储正弦波的值，并在时钟信号的驱动下逐步输出这些值，从而生成一个正弦波信号。

### Initialization
查找表`sin_wave`在模块初始化时通过外部文件`sine_wave.mem`加载，该文件包含256个8位的正弦波数据点。

### Operation
- 当复位信号`rst`为高电平时，索引`index`和输出信号`dac_out`被重置为0。
- 在每个时钟上升沿，模块从查找表中读取当前索引对应的正弦波值，并将其输出到`dac_out`，然后索引递增。

### Example
`sine_wave.mem`文件的内容示例：

`
00 19 32 4B 63 7B 92 A8 BD D1 E3 F4 02 10 1C 26 2E 34 38 3A 3A 38 34 2E 26 1C 10 02 F4 E3 D1 BD A8 92 7B 63 4B 32 19 00 E7 CE B5 9D 85 6E 58 43 2F 1D 0C FE F0 E4 DA D2 CC C8 C6 C6 C8 CC D2 DA E4 F0 FE 0C 1D 2F 43 58 6E 85 9D B5 CE E7
`

