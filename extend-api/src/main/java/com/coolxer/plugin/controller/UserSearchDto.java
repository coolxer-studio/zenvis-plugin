package com.coolxer.plugin.controller;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 资产主机数据传输对象
 */
@Data
@NoArgsConstructor
public class UserSearchDto {

    /**
     * ID
     */
    private String id;

    /**
     * 用户名称
     */
    private String name;

    /**
     * 身份编码
     */
    private String card;

    /**
     * 排序字段
     */
    private String orderBy;

    /**
     * 排序方式
     */
    private String orderDir;

    /**
     * 每页显示条数，默认 10
     */
    private int perPage = 10;

    /**
     * 当前页
     */
    private int page = 1;


}
