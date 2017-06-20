package com.ofs.model;

import lombok.Data;

@Data
public class Props {

    public enum Type {
        NUMBER,
        TEXT
    }

    private String name;
    private Type type;
    private boolean required;
}
