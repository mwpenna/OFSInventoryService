package com.ofs.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ofs.server.model.OFSEntity;
import com.ofs.server.utils.Dates;
import com.ofs.utils.StringUtils;
import lombok.Data;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Data
public class Inventory implements OFSEntity {

    private UUID id;
    private URI href;
    private ZonedDateTime createdOn;
    private String type;
    private List<Props> props;
    private String companyId;
    private double price;
    private int quantity;
    private String name;
    private String description;

    public Inventory() {

    }

    public Inventory(URI href) {
        this();
        this.href = href;
        this.createdOn = Dates.now();
        this.id = UUID.fromString(this.getIdFromHref());
    }

    public Inventory(Map map) {
        String href = (String)map.get("href");
        this.setHref(href != null ? URI.create(href) : null);

        String createdOn = (String) map.get("createdOn");
        this.setCreatedOn(createdOn != null ? ZonedDateTime.parse(createdOn) : null);

        this.setId(UUID.fromString((String)map.get("id")));
        this.setType((String) map.get("type"));
        this.setCompanyId((String) map.get("companyId"));
        this.setQuantity((int) map.get("quantity"));
//        this.setPrice((int) map.get("price"));
        this.setPrice(Double.parseDouble(map.get("price").toString()));
        this.setName((String) map.get("name"));
        this.setDescription((String) map.get("description"));

        ArrayList<Props> props = new ArrayList<>();

        for(Object prop : (List) map.get("props")) {
            props.add(new Props((Map) prop));
        }
        this.setProps(props);
    }

    @JsonIgnore
    public String getIdFromHref() {
        return StringUtils.getIdFromURI(getHref());
    }
}
