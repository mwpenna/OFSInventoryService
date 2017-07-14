package com.ofs.model;

import lombok.Data;

import java.util.Map;

@Data
public class Props {

    public Props(Map propMap) {
        this.name = (String) propMap.get("name");
        String type = (String) propMap.get("type");
        this.type = type != null ? Type.valueOf(type) : null;
        this.required = (Boolean) propMap.get("required");
        this.value = (String) propMap.get("value");
        this.defaultValue = (String) propMap.get("defaultValue");
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
    private String defaultValue;
}
