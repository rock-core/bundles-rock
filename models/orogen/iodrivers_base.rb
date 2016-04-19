module Base
    data_service_type 'RawIODeviceSrv' do
        input_port 'raw_in', '/iodrivers_base/RawPacket'
        output_port 'raw_out', '/iodrivers_base/RawPacket'
    end
end

class OroGen::IodriversBase::Task
    provides Base::RawIODeviceSrv, :as => 'raw_io',
        'raw_out' => 'io_raw_out',
        'raw_in' => 'io_raw_in'
end

