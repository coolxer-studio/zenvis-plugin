package com.coolxer.plugin.controller;

import lombok.AllArgsConstructor;
import lombok.Data;
import java.io.Serializable;

/**
 * 系统信息
 *
 * @author hunter
 */
@Data
@AllArgsConstructor
public class UserVo implements Serializable {

    private String id;
    private String user;
    private String card;

}
