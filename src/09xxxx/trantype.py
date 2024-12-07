#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# Copyright (C) 2024 - 2024 Sepine Tam, Inc. All Rights Reserved
#
# @Author : Sepine Tam
# @Email  : sepinetam@gmail.com
# @File   : trantype.py

import pandas as pd

name = "tea"
df = pd.read_csv(f'./{name}.csv', encoding='utf-8')
df.to_csv(f'./{name}2.csv', encoding='utf-8', index=False)
