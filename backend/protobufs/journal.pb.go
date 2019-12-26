// Code generated by protoc-gen-go. DO NOT EDIT.
// source: journal.proto

package protobufs

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

type Journal_JournalSaveType int32

const (
	Journal_LOCAL     Journal_JournalSaveType = 0
	Journal_PLAINTEXT Journal_JournalSaveType = 1
	Journal_ENCRYPTED Journal_JournalSaveType = 2
)

var Journal_JournalSaveType_name = map[int32]string{
	0: "LOCAL",
	1: "PLAINTEXT",
	2: "ENCRYPTED",
}

var Journal_JournalSaveType_value = map[string]int32{
	"LOCAL":     0,
	"PLAINTEXT": 1,
	"ENCRYPTED": 2,
}

func (x Journal_JournalSaveType) String() string {
	return proto.EnumName(Journal_JournalSaveType_name, int32(x))
}

func (Journal_JournalSaveType) EnumDescriptor() ([]byte, []int) {
	return fileDescriptor_04fd98cceb1b9191, []int{0, 0}
}

type Journal struct {
	Id                   int64                   `protobuf:"varint,1,opt,name=id,proto3" json:"id,omitempty"`
	UserId               int64                   `protobuf:"varint,2,opt,name=user_id,json=userId,proto3" json:"user_id,omitempty"`
	SaveType             Journal_JournalSaveType `protobuf:"varint,3,opt,name=save_type,json=saveType,proto3,enum=protobufs.Journal_JournalSaveType" json:"save_type,omitempty"`
	Content              string                  `protobuf:"bytes,4,opt,name=content,proto3" json:"content,omitempty"`
	CreatedAt            int64                   `protobuf:"varint,5,opt,name=created_at,json=createdAt,proto3" json:"created_at,omitempty"`
	UpdatedAt            int64                   `protobuf:"varint,6,opt,name=updated_at,json=updatedAt,proto3" json:"updated_at,omitempty"`
	XXX_NoUnkeyedLiteral struct{}                `json:"-"`
	XXX_unrecognized     []byte                  `json:"-"`
	XXX_sizecache        int32                   `json:"-"`
}

func (m *Journal) Reset()         { *m = Journal{} }
func (m *Journal) String() string { return proto.CompactTextString(m) }
func (*Journal) ProtoMessage()    {}
func (*Journal) Descriptor() ([]byte, []int) {
	return fileDescriptor_04fd98cceb1b9191, []int{0}
}

func (m *Journal) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_Journal.Unmarshal(m, b)
}
func (m *Journal) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_Journal.Marshal(b, m, deterministic)
}
func (m *Journal) XXX_Merge(src proto.Message) {
	xxx_messageInfo_Journal.Merge(m, src)
}
func (m *Journal) XXX_Size() int {
	return xxx_messageInfo_Journal.Size(m)
}
func (m *Journal) XXX_DiscardUnknown() {
	xxx_messageInfo_Journal.DiscardUnknown(m)
}

var xxx_messageInfo_Journal proto.InternalMessageInfo

func (m *Journal) GetId() int64 {
	if m != nil {
		return m.Id
	}
	return 0
}

func (m *Journal) GetUserId() int64 {
	if m != nil {
		return m.UserId
	}
	return 0
}

func (m *Journal) GetSaveType() Journal_JournalSaveType {
	if m != nil {
		return m.SaveType
	}
	return Journal_LOCAL
}

func (m *Journal) GetContent() string {
	if m != nil {
		return m.Content
	}
	return ""
}

func (m *Journal) GetCreatedAt() int64 {
	if m != nil {
		return m.CreatedAt
	}
	return 0
}

func (m *Journal) GetUpdatedAt() int64 {
	if m != nil {
		return m.UpdatedAt
	}
	return 0
}

type JournalResponse struct {
	Total                int64      `protobuf:"varint,1,opt,name=total,proto3" json:"total,omitempty"`
	Size                 int64      `protobuf:"varint,2,opt,name=size,proto3" json:"size,omitempty"`
	Journals             []*Journal `protobuf:"bytes,3,rep,name=journals,proto3" json:"journals,omitempty"`
	XXX_NoUnkeyedLiteral struct{}   `json:"-"`
	XXX_unrecognized     []byte     `json:"-"`
	XXX_sizecache        int32      `json:"-"`
}

func (m *JournalResponse) Reset()         { *m = JournalResponse{} }
func (m *JournalResponse) String() string { return proto.CompactTextString(m) }
func (*JournalResponse) ProtoMessage()    {}
func (*JournalResponse) Descriptor() ([]byte, []int) {
	return fileDescriptor_04fd98cceb1b9191, []int{1}
}

func (m *JournalResponse) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_JournalResponse.Unmarshal(m, b)
}
func (m *JournalResponse) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_JournalResponse.Marshal(b, m, deterministic)
}
func (m *JournalResponse) XXX_Merge(src proto.Message) {
	xxx_messageInfo_JournalResponse.Merge(m, src)
}
func (m *JournalResponse) XXX_Size() int {
	return xxx_messageInfo_JournalResponse.Size(m)
}
func (m *JournalResponse) XXX_DiscardUnknown() {
	xxx_messageInfo_JournalResponse.DiscardUnknown(m)
}

var xxx_messageInfo_JournalResponse proto.InternalMessageInfo

func (m *JournalResponse) GetTotal() int64 {
	if m != nil {
		return m.Total
	}
	return 0
}

func (m *JournalResponse) GetSize() int64 {
	if m != nil {
		return m.Size
	}
	return 0
}

func (m *JournalResponse) GetJournals() []*Journal {
	if m != nil {
		return m.Journals
	}
	return nil
}

func init() {
	proto.RegisterEnum("protobufs.Journal_JournalSaveType", Journal_JournalSaveType_name, Journal_JournalSaveType_value)
	proto.RegisterType((*Journal)(nil), "protobufs.Journal")
	proto.RegisterType((*JournalResponse)(nil), "protobufs.JournalResponse")
}

func init() { proto.RegisterFile("journal.proto", fileDescriptor_04fd98cceb1b9191) }

var fileDescriptor_04fd98cceb1b9191 = []byte{
	// 280 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x09, 0x6e, 0x88, 0x02, 0xff, 0x64, 0x90, 0x4f, 0x4f, 0x83, 0x40,
	0x10, 0xc5, 0x05, 0x0a, 0x74, 0xc7, 0xb4, 0x92, 0x89, 0x89, 0x5c, 0x4c, 0x0c, 0xa7, 0x9e, 0x38,
	0xd4, 0x9b, 0x17, 0x43, 0x2a, 0x87, 0x1a, 0x52, 0x9b, 0x95, 0x83, 0x9e, 0x08, 0x2d, 0x6b, 0x52,
	0x6d, 0x58, 0xc2, 0x2e, 0x26, 0xfa, 0x05, 0xfc, 0xda, 0x6e, 0x97, 0x85, 0x83, 0x9e, 0x66, 0xde,
	0xfb, 0xcd, 0x9f, 0xe4, 0xc1, 0xec, 0x9d, 0x77, 0x6d, 0x5d, 0x1e, 0xe3, 0xa6, 0xe5, 0x92, 0x23,
	0xd1, 0x65, 0xd7, 0xbd, 0x89, 0xe8, 0xc7, 0x06, 0xff, 0xb1, 0x87, 0x38, 0x07, 0xfb, 0x50, 0x85,
	0xd6, 0x8d, 0xb5, 0x70, 0xa8, 0xea, 0xf0, 0x0a, 0xfc, 0x4e, 0xb0, 0xb6, 0x50, 0xa6, 0xad, 0x4d,
	0xef, 0x24, 0xd7, 0x15, 0xde, 0x03, 0x11, 0xe5, 0x27, 0x2b, 0xe4, 0x57, 0xc3, 0x42, 0x47, 0xa1,
	0xf9, 0x32, 0x8a, 0xc7, 0x9b, 0xb1, 0xb9, 0x37, 0xd4, 0x67, 0x35, 0x9a, 0xab, 0x49, 0x3a, 0x15,
	0xa6, 0xc3, 0x10, 0xfc, 0x3d, 0xaf, 0x25, 0xab, 0x65, 0x38, 0x51, 0xeb, 0x84, 0x0e, 0x12, 0xaf,
	0x01, 0xf6, 0x2d, 0x2b, 0x25, 0xab, 0x8a, 0x52, 0x86, 0xae, 0x7e, 0x4b, 0x8c, 0x93, 0x68, 0xdc,
	0x35, 0xd5, 0x80, 0xbd, 0x1e, 0x1b, 0x27, 0x91, 0xd1, 0x1d, 0x5c, 0xfc, 0x79, 0x8a, 0x04, 0xdc,
	0xec, 0x69, 0x95, 0x64, 0xc1, 0x19, 0xce, 0x80, 0x6c, 0xb3, 0x64, 0xbd, 0xc9, 0xd3, 0x97, 0x3c,
	0xb0, 0x4e, 0x32, 0xdd, 0xac, 0xe8, 0xeb, 0x36, 0x4f, 0x1f, 0x02, 0x3b, 0xfa, 0x18, 0x77, 0x29,
	0x13, 0x0d, 0xaf, 0x05, 0xc3, 0x4b, 0x70, 0x25, 0x97, 0xe5, 0xd1, 0x64, 0xd2, 0x0b, 0x44, 0x98,
	0x88, 0xc3, 0x37, 0x33, 0x99, 0xe8, 0x1e, 0x63, 0x98, 0x9a, 0x88, 0x85, 0x0a, 0xc4, 0x59, 0x9c,
	0x2f, 0xf1, 0x7f, 0x20, 0x74, 0x9c, 0xd9, 0x79, 0x1a, 0xde, 0xfe, 0x06, 0x00, 0x00, 0xff, 0xff,
	0x27, 0x83, 0x94, 0x4a, 0x99, 0x01, 0x00, 0x00,
}
