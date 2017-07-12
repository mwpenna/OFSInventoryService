package com.ofs.controller;

import com.ofs.model.Inventory;
import com.ofs.repository.InventoryRepository;
import com.ofs.server.OFSController;
import com.ofs.server.OFSServerId;
import com.ofs.server.errors.NotFoundException;
import com.ofs.server.form.OFSServerForm;
import com.ofs.server.form.ValidationSchema;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.Authenticate;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validations.InventoryCompanyValidation;
import com.ofs.validators.inventory.InventoryCompanyIdValidator;
import com.ofs.validators.inventory.InventoryCompanyValidator;
import com.ofs.validators.inventory.InventoryCreateValidator;
import com.ofs.validators.inventory.InventoryDeleteValidator;
import com.ofs.validators.inventory.InventoryGetValidator;
import com.ofs.validators.inventory.InventoryUpdateValidator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@OFSController
@RequestMapping(value="/inventory", produces = MediaType.APPLICATION_JSON_VALUE)
@Slf4j
public class InventoryController {

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private InventoryCreateValidator inventoryCreateValidator;

    @Autowired
    private InventoryGetValidator inventoryGetValidator;

    @Autowired
    private InventoryCompanyIdValidator inventoryCompanyIdValidator;

    @Autowired
    private InventoryCompanyValidator inventoryCompanyValidation;

    @Autowired
    private InventoryDeleteValidator inventoryDeleteValidator;

    @Autowired
    private InventoryUpdateValidator inventoryUpdateValidator;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ValidationSchema(value = "/inventory-create.json")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity create(@OFSServerId URI id, OFSServerForm<Inventory> form) throws Exception{
        Inventory inventory = form.create(id);
        defaultValues(inventory);

        OFSErrors ofsErrors = new OFSErrors();
        inventoryCreateValidator.validate(inventory, ofsErrors);

        inventoryRepository.addInventory(inventory);
        return ResponseEntity.created(id).build();
    }

    @GetMapping(value = "/id/{id}")
    @Authenticate
    public Inventory getInventoryById(@PathVariable("id") String id) throws Exception {
        log.info("Retreiving Inventory item with id: {}", id);
        Optional<Inventory> inventoryOptional = inventoryRepository.getInventoryById(id);

        if(inventoryOptional.isPresent()) {
            Inventory inventory = inventoryOptional.get();

            OFSErrors errors = new OFSErrors();
            inventoryGetValidator.validate(inventory, errors);

            return inventory;
        }
        else {
            log.warn("Inventory Item with id: {} not found", id);
            throw new NotFoundException();
        }
    }

    @ResponseBody
    @GetMapping(value = "/company/id/{id}")
    @Authenticate
    @CrossOrigin(origins = "*")
    public List<Inventory> getByCompanyId(@PathVariable("id") String companyId) throws Exception {
        log.info("Retreiving invenory items with companyId: {}", companyId);
        Optional<List<Inventory>> inventoryListOptional = inventoryRepository.getInventoryByCompanyId(companyId);

        if(inventoryListOptional.isPresent()) {
            OFSErrors errors = new OFSErrors();
            inventoryCompanyIdValidator.validate(null, errors);
            inventoryCompanyValidation.validate(companyId, errors);

            return inventoryListOptional.get();
        }
        else {
            return new ArrayList<>();
        }
    }

    @DeleteMapping(value = "/id/{id}")
    @Authenticate
    public ResponseEntity delete(@PathVariable("id") String id) throws Exception {
        OFSErrors ofsErrors = new OFSErrors();
        inventoryDeleteValidator.validate(null, ofsErrors);

        Optional<Inventory> inventoryOptional = inventoryRepository.getInventoryById(id);

        if(inventoryOptional.isPresent()) {
            inventoryCompanyValidation.validate(inventoryOptional.get().getCompanyId(), ofsErrors);
            inventoryRepository.deleteTemplateById(id);
            return ResponseEntity.noContent().build();
        }
        else {
            throw new NotFoundException();
        }
    }

    @ValidationSchema(value = "/inventory-update.json")
    @PostMapping(value = "/id/{id}")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity updateInventoryById(@PathVariable("id") String inventoryId, OFSServerForm<Inventory> form) throws Exception {
        Optional<Inventory> inventoryOptional = inventoryRepository.getInventoryById(inventoryId);

        if(inventoryOptional.isPresent()) {
            Inventory inventory = inventoryOptional.get();

            ChangeSet changeSet = form.update(inventory);

            OFSErrors ofsErrors = new OFSErrors();
            inventoryUpdateValidator.validate(inventory, ofsErrors);
            inventoryCompanyValidation.validate(inventory.getCompanyId(), ofsErrors);

            if(changeSet.size()>0) {
                inventoryRepository.updateInventory(inventory);
            }
            return ResponseEntity.noContent().build();
        }
        else {
            log.error("Inventory with id: {} not found", inventoryId);
            throw new NotFoundException();
        }
    }

    private void defaultValues(Inventory inventory) {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") || inventory.getCompanyId()==null) {
            inventory.setCompanyId(StringUtils.getIdFromURI(subject.getCompanyHref()));
        }
    }
}
