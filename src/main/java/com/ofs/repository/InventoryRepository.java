package com.ofs.repository;

import com.couchbase.client.java.document.json.JsonObject;
import com.couchbase.client.java.error.DocumentDoesNotExistException;
import com.couchbase.client.java.error.TemporaryFailureException;
import com.couchbase.client.java.query.ParameterizedN1qlQuery;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Inventory;
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
@OFSRepository("inventory")
public class InventoryRepository extends BaseCouchbaseRepository<Inventory> {

    @Autowired
    ConnectionManager connectionManager;

    public void addInventory(Inventory inventory) throws JsonProcessingException {
        Objects.requireNonNull(inventory);

        log.info("Attempting to add template with id: {}", inventory.getId());
        add(inventory.getId().toString(), connectionManager.getBucket("inventory"), inventory);
        log.info("Template with id: {} has been added", inventory.getId());
    }

    public Optional<Inventory> getInventoryById(String id) {
        if(id == null) {
            log.warn("Cannot get template by id with null id");
            return Optional.empty();
        }

        return queryForObjectById(id, connectionManager.getBucket("inventory"), Inventory.class);
    }

    public Optional<List<Inventory>> getInventoryByCompanyId(String companyId) throws Exception {
        try {
            ParameterizedN1qlQuery query = ParameterizedN1qlQuery.parameterized(
                    generateGetByCompanyIdQuery(), generateGetByCompanyIdParameters(companyId));
            return queryForObjectListByParameters(query, connectionManager.getBucket("inventory"), Inventory.class);
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
            log.info("Attempting to delete inventory item with id: {}", id);
            delete(id, connectionManager.getBucket("inventory"));
            log.info("inventory item with id: {} has been delete", id);
        }
        catch (DocumentDoesNotExistException e) {
            log.warn("User with id: {} was not found", id);
            throw new NotFoundException();
        }
        catch (TemporaryFailureException e) {
            log.error("Temporary Failure with couchbase occurred" , e);
            throw new ServiceUnavailableException();
        }
    }

    public void updateInventory(Inventory inventory) throws JsonProcessingException {
        Objects.requireNonNull(inventory);

        try{
            log.info("Attempting to update inventory with id: {}", inventory.getId());
            update(inventory.getId().toString(), connectionManager.getBucket("inventory"), inventory);
            log.info("Inventory with id: {} has been updated", inventory.getId());
        }
        catch(DocumentDoesNotExistException e) {
            log.warn("Inventory with id: {} was not found", inventory.getId());
            throw new NotFoundException();
        }
        catch (TemporaryFailureException e) {
            log.error("Temporary Failure with Couchbase occurred" , e);
            throw new ServiceUnavailableException();
        }
    }

    private String generateGetByCompanyIdQuery() {
        return "SELECT `" + connectionManager.getBucket("inventory").name() + "`.* FROM `" + connectionManager.getBucket("inventory").name()
                + "` where companyId = $companyId";
    }

    private JsonObject generateGetByCompanyIdParameters(String companyId) {
        return JsonObject.create().put("$companyId", companyId);
    }
}
