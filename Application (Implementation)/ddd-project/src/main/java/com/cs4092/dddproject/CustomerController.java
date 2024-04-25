package com.cs4092.dddproject;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*")
public class CustomerController {
    private final CustomerService customerService;

    // Dependency injection
    @Autowired
    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    // Create a new customer
    @PostMapping
    public ResponseEntity<Customer> createCustomer(@Valid @RequestBody Customer customer) {
        Customer savedCustomer = customerService.addCustomer(customer);
        return new ResponseEntity<>(savedCustomer, HttpStatus.CREATED);
    }

    // Add a new address for a customer by ID
    @PostMapping("/{customerId}/addresses")
    public ResponseEntity<Customer> addAddress(@PathVariable Long customerId, @Valid @RequestBody Address address) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        customerService.addAddress(customer, address);
        return new ResponseEntity<>(customer, HttpStatus.OK);
    }

    // Update an existing address for a customer by ID
    @PutMapping("/{customerId}/addresses/{addressId}")
    public ResponseEntity<Customer> updateAddress(@PathVariable Long customerId, @PathVariable Long addressId, @Valid @RequestBody Address updatedAddress) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        try {
            customerService.updateAddress(customer, updatedAddress);
            return new ResponseEntity<>(customerService.getCustomerById(customerId), HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            // TODO: add message for exception
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // Add a new credit card for a customer by ID
    @PostMapping("/{customerId}/credit-cards")
    public ResponseEntity<Customer> addCreditCard(@PathVariable Long customerId, @Valid @RequestBody CreditCard creditCard) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        customerService.addCreditCard(customer, creditCard);
        return new ResponseEntity<>(customer, HttpStatus.OK);
    }

    // This might be better placed in OrderController depending on our architecture
    // @PostMapping("/{customerId}/orders")
    // public ResponseEntity<Order> placeOrder(@PathVariable Long customerId, @Valid @RequestBody Order order) {
    //     Customer customer = customerService.getCustomerById(customerId);
    //     if (customer == null) {
    //         return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    //     }
    //     Order savedOrder = customerService.placeOrder(customer, order);
    //     return new ResponseEntity<>(savedOrder, HttpStatus.CREATED);
    // }

    // Find a customer by ID
    @GetMapping("/{id}")
    public ResponseEntity<Customer> getCustomerById(@PathVariable Long id) {
        Customer customer = customerService.getCustomerById(id);
        if (customer == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(customer, HttpStatus.OK);
    }
}
