import sys
import os
import pandas as pd


def process(input_file, output_file=None):
    if output_file is None:
        base_name, ext = os.path.splitext(input_file)
        output_file = f"{base_name}_processed.csv"
    # df = pd.read_csv(input_file, dtype={"时间": "string", "商品": "string"})
    df = pd.read_csv(input_file, encoding='gbk')
    df[["month", "year"]] = df["时间"].str.split('-', expand=True)
    df['time_index'] = df['year'] + df['month'].str.zfill(2)
    df['goods_code'] = df["商品"].str.split(' - ').str[0].str.strip()
    df['IPQ'] = df['指标'] == "进口金额（美元）"
    df['XPQ'] = df['指标'] == "出口金额（美元）"
    df['IQ'] = df['指标'] == "进口数量（第一数量）"
    df['XQ'] = df['指标'] == "出口数量（第一数量）"
    df['is_US'] = df['国家'] == "美国"
    # df['IP'] =
    df.to_csv(output_file, index=False, encoding='utf-8')
    print("RUN OVER!")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("WRONG!")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    process(input_file, output_file)
