package com.ofs.repository;

import com.couchbase.client.java.document.json.JsonObject;
import com.couchbase.client.java.error.DocumentDoesNotExistException;
import com.couchbase.client.java.error.TemporaryFailureException;
import com.couchbase.client.java.query.ParameterizedN1qlQuery;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Template;
import com.ofs.server.errors.NotFoundException;
import com.ofs.server.errors.ServiceUnavailableException;
import com.ofs.server.repository.BaseCouchbaseRepository;
import com.ofs.server.repository.ConnectionManager;
import com.ofs.server.repository.OFSRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
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

    public Optional<List<Template>> getTemplateByCompanyId(String companyId) throws Exception {
        try {
            ParameterizedN1qlQuery query = ParameterizedN1qlQuery.parameterized(
                    generateGetByCompanyIdQuery(), generateGetByCompanyIdParameters(companyId));
            return queryForObjectListByParameters(query, connectionManager.getBucket("template"), Template.class);
        }
        catch (NoSuchElementException e) {
            log.info("No results returned for getTemplatebyName with companyId: {}", companyId);
            return Optional.empty();
        }
        catch (TemporaryFailureException e) {
            log.error("Temporary Failure with couchbase occured" , e);
            throw new ServiceUnavailableException();
        }
    }

    public void deleteTemplateById(String id) {
        Objects.requireNonNull(id);

        try{
            log.info("Attempting to delete user with id: {}", id);
            delete(id, connectionManager.getBucket("template"));
            log.info("template with id: {} has been delete", id);
        }
        catch (DocumentDoesNotExistException e) {
            log.warn("Template with id: {} was not found", id);
            throw new NotFoundException();
        }
        catch (TemporaryFailureException e) {
            log.error("Temporary Failure with couchbase occurred" , e);
            throw new ServiceUnavailableException();
        }
    }

    public Optional<Template> getTemplateById(String id) {
        if(id == null) {
            log.warn("Cannot get template by id with null id");
            return Optional.empty();
        }

        return queryForObjectById(id, connectionManager.getBucket("template"), Template.class);
    }

    private String generateGetByNameQuery() {
        return "SELECT `" + connectionManager.getBucket("template").name() + "`.* FROM `" + connectionManager.getBucket("template").name()
                + "` where name = $name and companyId = $companyId";
    }

    private JsonObject generateGetByNameParameters(String name, String companyId) {
        return JsonObject.create().put("$name", name).put("$companyId", companyId);
    }

    private String generateGetByCompanyIdQuery() {
        return "SELECT `" + connectionManager.getBucket("template").name() + "`.* FROM `" + connectionManager.getBucket("template").name()
                + "` where companyId = $companyId";
    }

    private JsonObject generateGetByCompanyIdParameters(String companyId) {
        return JsonObject.create().put("$companyId", companyId);
    }

}
