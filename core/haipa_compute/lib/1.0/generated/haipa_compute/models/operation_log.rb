# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Haipa::Client::Compute::V1_0
  module Models
    #
    # Model object.
    #
    #
    class OperationLog

      include Haipa::Client

      # @return
      attr_accessor :id

      # @return [String]
      attr_accessor :message

      # @return [DateTime]
      attr_accessor :timestamp

      # @return [Operation]
      attr_accessor :operation


      #
      # Mapper for OperationLog class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          client_side_validation: true,
          required: false,
          serialized_name: 'OperationLog',
          type: {
            name: 'Composite',
            class_name: 'OperationLog',
            model_properties: {
              id: {
                client_side_validation: true,
                required: false,
                serialized_name: 'id',
                type: {
                  name: 'String'
                }
              },
              message: {
                client_side_validation: true,
                required: false,
                serialized_name: 'message',
                type: {
                  name: 'String'
                }
              },
              timestamp: {
                client_side_validation: true,
                required: false,
                serialized_name: 'timestamp',
                type: {
                  name: 'DateTime'
                }
              },
              operation: {
                client_side_validation: true,
                required: false,
                serialized_name: 'operation',
                type: {
                  name: 'Composite',
                  class_name: 'Operation'
                }
              }
            }
          }
        }
      end
    end
  end
end