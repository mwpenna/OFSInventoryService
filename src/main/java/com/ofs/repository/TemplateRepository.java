package com.ofs.repository;

import com.couchbase.client.java.document.json.JsonObject;
import com.couchbase.client.java.error.TemporaryFailureException;
import com.couchbase.client.java.query.ParameterizedN1qlQuery;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Template;
import com.ofs.server.errors.ServiceUnavailableException;
import com.ofs.server.repository.BaseCouchbaseRepository;
import com.ofs.server.repository.ConnectionManager;
import com.ofs.server.repository.OFSRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;

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

    public Optional<Template> getTemplateByName(String name, String companyId) throws Exception {
        if(name == null) {
            return Optional.empty();
        }

        try {
            ParameterizedN1qlQuery query = ParameterizedN1qlQuery.parameterized(
                    generateGetByNameQuery(), generateGetByNameParameters(name, companyId));
            return queryForObjectByParameters(query, connectionManager.getBucket("template"), Template.class);
        }
        catch (NoSuchElementException e) {
            log.info("No results returned for getTemplatebyName with name: {}", name);
            return Optional.empty();
        }
        catch (TemporaryFailureException e) {
            log.error("Temporary Failure with couchbase occured" , e);
            throw new ServiceUnavailableException();
        }
    }

    private String generateGetByNameQuery() {
        return "SELECT `" + connectionManager.getBucket("template").name() + "`.* FROM `" + connectionManager.getBucket("template").name()
                + "` where name = $name and companyId = $companyId";
    }

    private JsonObject generateGetByNameParameters(String name, String companyId) {
        return JsonObject.create().put("$name", name).put("$companyId", companyId);
    }
}
