package com.coolxer.plugin.controller;


import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 资产主机数据传输对象
 */
@Data
@NoArgsConstructor
public class UserDto {

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


}
