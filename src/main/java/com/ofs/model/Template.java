package com.ofs.model;

import com.ofs.server.model.OFSEntity;
import lombok.Data;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Data
public class Template implements OFSEntity{
    private UUID id;
    private URI href;
    private ZonedDateTime createdOn;
    private String name;
    private List<Props> props;
}
