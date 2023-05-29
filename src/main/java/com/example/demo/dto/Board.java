package com.example.demo.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class Board {
	
	private int bno;
	private String title;
	private String writer;
	private Date regDate;

}
