
# Entity: my_codelock 
- **File**: my_codelock.v

## Diagram
![Diagram](my_codelock.svg "Diagram")
## Ports

| Port name   | Direction | Type  | Description        |
| ----------- | --------- | ----- | ------------------ |
| clk         | input     |       |                    |
| rst         | input     |       | 重置，对应KEY1     |
| key_confirm | input     |       | 确认密码，对应KEY2 |
| key_set     | input     |       | 设置密码，对应KEY3 |
| sw_password | input     | [3:0] |                    |
| led         | output    | [1:0] |                    |
| sega        | output    | [8:0] |                    |

## Signals

| Name              | Type      | Description |
| ----------------- | --------- | ----------- |
| password =4'b0000 | reg       |             |
| sgn               | reg [1:0] |             |
| seg[3:0]          | reg [8:0] |             |
| seg_data[1:0]     | reg [8:0] |             |
| cnt               | reg [1:0] |             |
| lock              | reg       |             |
| confirm_dbs       | wire      |             |

## Processes
- unnamed: ( @ (posedge clk or negedge rst) )
  - **Type:** always

## Instantiations

- key_confirm_dbs: debounce
