package com.ofs.repository;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Inventory;
import com.ofs.server.repository.BaseCouchbaseRepository;
import com.ofs.server.repository.ConnectionManager;
import com.ofs.server.repository.OFSRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
}
