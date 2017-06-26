package com.ofs.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ofs.server.model.OFSEntity;
import com.ofs.server.utils.Dates;
import com.ofs.utils.StringUtils;
import lombok.Data;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.List;
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

    private UUID id;
    private URI href;
    private ZonedDateTime createdOn;
    private String name;
    private List<Props> props;
    private URI companyHref;

    @JsonIgnore
    public String getIdFromHref() {
        return StringUtils.getIdFromURI(getHref());
    }

    @JsonIgnore
    public String getCompanyIdFromHref() {
        return StringUtils.getIdFromURI(getCompanyHref());
    }
}
