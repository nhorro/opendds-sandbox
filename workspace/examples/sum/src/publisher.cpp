#include "SumC.h"
#include "SumTypeSupportImpl.h"

#include <dds/DCPS/Service_Participant.h>
#include <dds/DCPS/Marked_Default_Qos.h>
#include <dds/DCPS/StaticIncludes.h>
#include <ace/streams.h>

int main(int argc, char* argv[]) {
  using namespace SumModule;

  DDS::DomainParticipantFactory_var dpf = TheParticipantFactoryWithArgs(argc, argv);

  DDS::DomainParticipant_var participant =
    dpf->create_participant(42, PARTICIPANT_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  SumRequestTypeSupport_var ts_req = new SumRequestTypeSupport;
  SumResponseTypeSupport_var ts_res = new SumResponseTypeSupport;

  ts_req->register_type(participant, "");
  ts_res->register_type(participant, "");

  CORBA::String_var type_name_req = ts_req->get_type_name();
  CORBA::String_var type_name_res = ts_res->get_type_name();

  DDS::Topic_var topic_req = participant->create_topic(
    "SumRequest", type_name_req, TOPIC_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  DDS::Topic_var topic_res = participant->create_topic(
    "SumResponse", type_name_res, TOPIC_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  DDS::Publisher_var publisher = participant->create_publisher(
    PUBLISHER_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  DDS::DataWriter_var writer = publisher->create_datawriter(
    topic_req, DATAWRITER_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  SumRequestDataWriter_var sum_writer = SumRequestDataWriter::_narrow(writer);

  DDS::Subscriber_var subscriber = participant->create_subscriber(
    SUBSCRIBER_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  DDS::DataReader_var reader = subscriber->create_datareader(
    topic_res, DATAREADER_QOS_DEFAULT, 0, OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  SumResponseDataReader_var sum_reader = SumResponseDataReader::_narrow(reader);

  SumRequest req;
  req.a = 12;
  req.b = 30;

  std::cout << "[Publisher] Enviando: a = " << req.a << ", b = " << req.b << std::endl;
  sum_writer->write(req, DDS::HANDLE_NIL);

  SumResponse res;
  DDS::SampleInfo info;

  while (true) {
    if (sum_reader->take_next_sample(res, info) == DDS::RETCODE_OK && info.valid_data) {
      std::cout << "[Publisher] Recibido resultado: " << res.result << std::endl;
      break;
    }
    ACE_OS::sleep(1);
  }

  return 0;
}
