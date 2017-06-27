package com.ofs.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ofs.server.model.OFSEntity;
import com.ofs.server.utils.Dates;
import com.ofs.utils.StringUtils;
import lombok.Data;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Data
public class Template implements OFSEntity{

    public Template() {

    }

    public Template(URI href) {
        this();
        this.href = href;
        this.createdOn = Dates.now();
        this.id = UUID.fromString(this.getIdFromHref());
    }

    public Template(Map map) {
        String href = (String)map.get("href");
        this.setHref(href != null ? URI.create(href) : null);

        String createdOn = (String) map.get("createdOn");
        this.setCreatedOn(createdOn != null ? ZonedDateTime.parse(createdOn) : null);

        this.setId(UUID.fromString((String)map.get("id")));
        this.setName((String) map.get("name"));
        this.setCompanyId((String) map.get("companyId"));
        this.setProps((List) map.get("props"));
    }

    private UUID id;
    private URI href;
    private ZonedDateTime createdOn;
    private String name;
    private List<Props> props;
    private String companyId;

    @JsonIgnore
    public String getIdFromHref() {
        return StringUtils.getIdFromURI(getHref());
    }
}
