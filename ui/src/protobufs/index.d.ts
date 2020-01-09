import * as Long from "long"; 
import * as $protobuf from "protobufjs";
/** Namespace protobufs. */
export namespace protobufs {

    /** Properties of a HttpApiQueue. */
    interface IHttpApiQueue {

        /** HttpApiQueue queue */
        queue?: (protobufs.IHttpApiQueueItem[]|null);
    }

    /** Represents a HttpApiQueue. */
    class HttpApiQueue implements IHttpApiQueue {

        /**
         * Constructs a new HttpApiQueue.
         * @param [properties] Properties to set
         */
        constructor(properties?: protobufs.IHttpApiQueue);

        /** HttpApiQueue queue. */
        public queue: protobufs.IHttpApiQueueItem[];

        /**
         * Creates a new HttpApiQueue instance using the specified properties.
         * @param [properties] Properties to set
         * @returns HttpApiQueue instance
         */
        public static create(properties?: protobufs.IHttpApiQueue): protobufs.HttpApiQueue;

        /**
         * Encodes the specified HttpApiQueue message. Does not implicitly {@link protobufs.HttpApiQueue.verify|verify} messages.
         * @param message HttpApiQueue message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: protobufs.IHttpApiQueue, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified HttpApiQueue message, length delimited. Does not implicitly {@link protobufs.HttpApiQueue.verify|verify} messages.
         * @param message HttpApiQueue message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: protobufs.IHttpApiQueue, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a HttpApiQueue message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns HttpApiQueue
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): protobufs.HttpApiQueue;

        /**
         * Decodes a HttpApiQueue message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns HttpApiQueue
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): protobufs.HttpApiQueue;

        /**
         * Verifies a HttpApiQueue message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a HttpApiQueue message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns HttpApiQueue
         */
        public static fromObject(object: { [k: string]: any }): protobufs.HttpApiQueue;

        /**
         * Creates a plain object from a HttpApiQueue message. Also converts values to other types if specified.
         * @param message HttpApiQueue
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: protobufs.HttpApiQueue, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this HttpApiQueue to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };
    }

    /** Properties of a HttpApiQueueItem. */
    interface IHttpApiQueueItem {

        /** HttpApiQueueItem type */
        type?: (protobufs.HttpApiQueueItem.HttpApiQueueItemType|null);

        /** HttpApiQueueItem params */
        params?: ({ [k: string]: string }|null);
    }

    /** Represents a HttpApiQueueItem. */
    class HttpApiQueueItem implements IHttpApiQueueItem {

        /**
         * Constructs a new HttpApiQueueItem.
         * @param [properties] Properties to set
         */
        constructor(properties?: protobufs.IHttpApiQueueItem);

        /** HttpApiQueueItem type. */
        public type: protobufs.HttpApiQueueItem.HttpApiQueueItemType;

        /** HttpApiQueueItem params. */
        public params: { [k: string]: string };

        /**
         * Creates a new HttpApiQueueItem instance using the specified properties.
         * @param [properties] Properties to set
         * @returns HttpApiQueueItem instance
         */
        public static create(properties?: protobufs.IHttpApiQueueItem): protobufs.HttpApiQueueItem;

        /**
         * Encodes the specified HttpApiQueueItem message. Does not implicitly {@link protobufs.HttpApiQueueItem.verify|verify} messages.
         * @param message HttpApiQueueItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: protobufs.IHttpApiQueueItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified HttpApiQueueItem message, length delimited. Does not implicitly {@link protobufs.HttpApiQueueItem.verify|verify} messages.
         * @param message HttpApiQueueItem message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: protobufs.IHttpApiQueueItem, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a HttpApiQueueItem message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns HttpApiQueueItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): protobufs.HttpApiQueueItem;

        /**
         * Decodes a HttpApiQueueItem message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns HttpApiQueueItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): protobufs.HttpApiQueueItem;

        /**
         * Verifies a HttpApiQueueItem message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a HttpApiQueueItem message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns HttpApiQueueItem
         */
        public static fromObject(object: { [k: string]: any }): protobufs.HttpApiQueueItem;

        /**
         * Creates a plain object from a HttpApiQueueItem message. Also converts values to other types if specified.
         * @param message HttpApiQueueItem
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: protobufs.HttpApiQueueItem, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this HttpApiQueueItem to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };
    }

    namespace HttpApiQueueItem {

        /** HttpApiQueueItemType enum. */
        enum HttpApiQueueItemType {
            NEW_JOURNAL = 0,
            SAVE_JOURNAL = 1,
            DELETE_JOURNAL = 2
        }
    }

    /** Properties of a Journal. */
    interface IJournal {

        /** Journal id */
        id?: (number|Long|null);

        /** Journal userId */
        userId?: (number|Long|null);

        /** Journal saveType */
        saveType?: (protobufs.Journal.JournalSaveType|null);

        /** Journal content */
        content?: (string|null);

        /** Journal createdAt */
        createdAt?: (number|Long|null);

        /** Journal updatedAt */
        updatedAt?: (number|Long|null);
    }

    /** Represents a Journal. */
    class Journal implements IJournal {

        /**
         * Constructs a new Journal.
         * @param [properties] Properties to set
         */
        constructor(properties?: protobufs.IJournal);

        /** Journal id. */
        public id: (number|Long);

        /** Journal userId. */
        public userId: (number|Long);

        /** Journal saveType. */
        public saveType: protobufs.Journal.JournalSaveType;

        /** Journal content. */
        public content: string;

        /** Journal createdAt. */
        public createdAt: (number|Long);

        /** Journal updatedAt. */
        public updatedAt: (number|Long);

        /**
         * Creates a new Journal instance using the specified properties.
         * @param [properties] Properties to set
         * @returns Journal instance
         */
        public static create(properties?: protobufs.IJournal): protobufs.Journal;

        /**
         * Encodes the specified Journal message. Does not implicitly {@link protobufs.Journal.verify|verify} messages.
         * @param message Journal message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: protobufs.IJournal, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified Journal message, length delimited. Does not implicitly {@link protobufs.Journal.verify|verify} messages.
         * @param message Journal message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: protobufs.IJournal, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a Journal message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns Journal
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): protobufs.Journal;

        /**
         * Decodes a Journal message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns Journal
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): protobufs.Journal;

        /**
         * Verifies a Journal message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a Journal message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns Journal
         */
        public static fromObject(object: { [k: string]: any }): protobufs.Journal;

        /**
         * Creates a plain object from a Journal message. Also converts values to other types if specified.
         * @param message Journal
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: protobufs.Journal, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this Journal to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };
    }

    namespace Journal {

        /** JournalSaveType enum. */
        enum JournalSaveType {
            LOCAL = 0,
            PLAINTEXT = 1,
            ENCRYPTED = 2
        }
    }

    /** Properties of a JournalResponse. */
    interface IJournalResponse {

        /** JournalResponse total */
        total?: (number|Long|null);

        /** JournalResponse size */
        size?: (number|Long|null);

        /** JournalResponse journals */
        journals?: (protobufs.IJournal[]|null);
    }

    /** Represents a JournalResponse. */
    class JournalResponse implements IJournalResponse {

        /**
         * Constructs a new JournalResponse.
         * @param [properties] Properties to set
         */
        constructor(properties?: protobufs.IJournalResponse);

        /** JournalResponse total. */
        public total: (number|Long);

        /** JournalResponse size. */
        public size: (number|Long);

        /** JournalResponse journals. */
        public journals: protobufs.IJournal[];

        /**
         * Creates a new JournalResponse instance using the specified properties.
         * @param [properties] Properties to set
         * @returns JournalResponse instance
         */
        public static create(properties?: protobufs.IJournalResponse): protobufs.JournalResponse;

        /**
         * Encodes the specified JournalResponse message. Does not implicitly {@link protobufs.JournalResponse.verify|verify} messages.
         * @param message JournalResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: protobufs.IJournalResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified JournalResponse message, length delimited. Does not implicitly {@link protobufs.JournalResponse.verify|verify} messages.
         * @param message JournalResponse message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: protobufs.IJournalResponse, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a JournalResponse message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns JournalResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): protobufs.JournalResponse;

        /**
         * Decodes a JournalResponse message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns JournalResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): protobufs.JournalResponse;

        /**
         * Verifies a JournalResponse message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a JournalResponse message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns JournalResponse
         */
        public static fromObject(object: { [k: string]: any }): protobufs.JournalResponse;

        /**
         * Creates a plain object from a JournalResponse message. Also converts values to other types if specified.
         * @param message JournalResponse
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: protobufs.JournalResponse, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this JournalResponse to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };
    }

    /** Properties of a User. */
    interface IUser {

        /** User id */
        id?: (number|Long|null);

        /** User email */
        email?: (string|null);

        /** User firstName */
        firstName?: (string|null);

        /** User lastName */
        lastName?: (string|null);

        /** User createdAt */
        createdAt?: (number|Long|null);

        /** User updatedAt */
        updatedAt?: (number|Long|null);
    }

    /** Represents a User. */
    class User implements IUser {

        /**
         * Constructs a new User.
         * @param [properties] Properties to set
         */
        constructor(properties?: protobufs.IUser);

        /** User id. */
        public id: (number|Long);

        /** User email. */
        public email: string;

        /** User firstName. */
        public firstName: string;

        /** User lastName. */
        public lastName: string;

        /** User createdAt. */
        public createdAt: (number|Long);

        /** User updatedAt. */
        public updatedAt: (number|Long);

        /**
         * Creates a new User instance using the specified properties.
         * @param [properties] Properties to set
         * @returns User instance
         */
        public static create(properties?: protobufs.IUser): protobufs.User;

        /**
         * Encodes the specified User message. Does not implicitly {@link protobufs.User.verify|verify} messages.
         * @param message User message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encode(message: protobufs.IUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Encodes the specified User message, length delimited. Does not implicitly {@link protobufs.User.verify|verify} messages.
         * @param message User message or plain object to encode
         * @param [writer] Writer to encode to
         * @returns Writer
         */
        public static encodeDelimited(message: protobufs.IUser, writer?: $protobuf.Writer): $protobuf.Writer;

        /**
         * Decodes a User message from the specified reader or buffer.
         * @param reader Reader or buffer to decode from
         * @param [length] Message length if known beforehand
         * @returns User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decode(reader: ($protobuf.Reader|Uint8Array), length?: number): protobufs.User;

        /**
         * Decodes a User message from the specified reader or buffer, length delimited.
         * @param reader Reader or buffer to decode from
         * @returns User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        public static decodeDelimited(reader: ($protobuf.Reader|Uint8Array)): protobufs.User;

        /**
         * Verifies a User message.
         * @param message Plain object to verify
         * @returns `null` if valid, otherwise the reason why it is not
         */
        public static verify(message: { [k: string]: any }): (string|null);

        /**
         * Creates a User message from a plain object. Also converts values to their respective internal types.
         * @param object Plain object
         * @returns User
         */
        public static fromObject(object: { [k: string]: any }): protobufs.User;

        /**
         * Creates a plain object from a User message. Also converts values to other types if specified.
         * @param message User
         * @param [options] Conversion options
         * @returns Plain object
         */
        public static toObject(message: protobufs.User, options?: $protobuf.IConversionOptions): { [k: string]: any };

        /**
         * Converts this User to JSON.
         * @returns JSON object
         */
        public toJSON(): { [k: string]: any };
    }
}
