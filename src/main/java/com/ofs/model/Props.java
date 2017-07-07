package com.ofs.model;

import lombok.Data;

import java.util.Map;

@Data
public class Props {

    public Props(Map propMap) {
        this.name = (String) propMap.get("name");
        String type = (String) propMap.get("type");
        this.type = Type.valueOf(type);
        this.required = (Boolean) propMap.get("required");
        this.value = (String) propMap.get("value");
    }

    public Props() {

    }

    public enum Type {
        NUMBER,
        STRING,
        BOOLEAN
    }

    private String name;
    private Type type;
    private boolean required;
    private String value;
}
