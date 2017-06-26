package com.ofs.repository;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Template;
import com.ofs.server.repository.BaseCouchbaseRepository;
import com.ofs.server.repository.ConnectionManager;
import com.ofs.server.repository.OFSRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Slf4j
@Component
@OFSRepository("template")
public class TemplateRepository extends BaseCouchbaseRepository<Template>{

    @Autowired
    ConnectionManager connectionManager;

    public void addTemplate(Template template) throws JsonProcessingException {
        Objects.requireNonNull(template);

        log.info("Attempting to add template with id: {}", template.getId());
        add(template.getId().toString(), connectionManager.getBucket("template"), template);
        log.info("Template with id: {} has been added", template.getId());
    }
}
