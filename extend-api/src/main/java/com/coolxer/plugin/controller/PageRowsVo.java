package com.coolxer.plugin.controller;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageRowsVo<T> {
    private List<T> rows;
    private long total;

}
