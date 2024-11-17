module MyModule::MedicalRecords {

    use aptos_framework::signer;
    use aptos_framework::vector;

    /// Struct representing a patient's medical record.
    struct MedicalRecord has store, key {
        patient_address: address,   // The patient's address
        record_data: vector<u8>,     // The medical data (represented as a byte vector)
        authorized_addresses: vector<address>, // List of addresses authorized to view the record
    }

    /// Function to create a new medical record for a patient.
    public fun create_medical_record(owner: &signer, record_data: vector<u8>) {
        let patient_address = signer::address_of(owner);
        let record = MedicalRecord {
            patient_address,
            record_data,
            authorized_addresses: vector::empty<address>(), // Corrected empty vector initialization
        };
        move_to(owner, record);
    }

    /// Function for a patient to authorize access to their medical record.
    public fun authorize_access(patient: &signer, authorized_address: address) acquires MedicalRecord {
        let record = borrow_global_mut<MedicalRecord>(signer::address_of(patient));

        // Ensure the address is not already authorized
        if (!vector::contains(&record.authorized_addresses, &authorized_address)) {
            vector::push_back(&mut record.authorized_addresses, authorized_address);
        }
    }
}
