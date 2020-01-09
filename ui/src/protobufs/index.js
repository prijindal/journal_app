/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
"use strict";

var $protobuf = require("protobufjs/minimal");

// Common aliases
var $Reader = $protobuf.Reader, $Writer = $protobuf.Writer, $util = $protobuf.util;

// Exported root namespace
var $root = $protobuf.roots["default"] || ($protobuf.roots["default"] = {});

$root.protobufs = (function() {

    /**
     * Namespace protobufs.
     * @exports protobufs
     * @namespace
     */
    var protobufs = {};

    protobufs.HttpApiQueue = (function() {

        /**
         * Properties of a HttpApiQueue.
         * @memberof protobufs
         * @interface IHttpApiQueue
         * @property {Array.<protobufs.IHttpApiQueueItem>|null} [queue] HttpApiQueue queue
         */

        /**
         * Constructs a new HttpApiQueue.
         * @memberof protobufs
         * @classdesc Represents a HttpApiQueue.
         * @implements IHttpApiQueue
         * @constructor
         * @param {protobufs.IHttpApiQueue=} [properties] Properties to set
         */
        function HttpApiQueue(properties) {
            this.queue = [];
            if (properties)
                for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * HttpApiQueue queue.
         * @member {Array.<protobufs.IHttpApiQueueItem>} queue
         * @memberof protobufs.HttpApiQueue
         * @instance
         */
        HttpApiQueue.prototype.queue = $util.emptyArray;

        /**
         * Creates a new HttpApiQueue instance using the specified properties.
         * @function create
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {protobufs.IHttpApiQueue=} [properties] Properties to set
         * @returns {protobufs.HttpApiQueue} HttpApiQueue instance
         */
        HttpApiQueue.create = function create(properties) {
            return new HttpApiQueue(properties);
        };

        /**
         * Encodes the specified HttpApiQueue message. Does not implicitly {@link protobufs.HttpApiQueue.verify|verify} messages.
         * @function encode
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {protobufs.IHttpApiQueue} message HttpApiQueue message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        HttpApiQueue.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.queue != null && message.queue.length)
                for (var i = 0; i < message.queue.length; ++i)
                    $root.protobufs.HttpApiQueueItem.encode(message.queue[i], writer.uint32(/* id 1, wireType 2 =*/10).fork()).ldelim();
            return writer;
        };

        /**
         * Encodes the specified HttpApiQueue message, length delimited. Does not implicitly {@link protobufs.HttpApiQueue.verify|verify} messages.
         * @function encodeDelimited
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {protobufs.IHttpApiQueue} message HttpApiQueue message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        HttpApiQueue.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a HttpApiQueue message from the specified reader or buffer.
         * @function decode
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {protobufs.HttpApiQueue} HttpApiQueue
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        HttpApiQueue.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            var end = length === undefined ? reader.len : reader.pos + length, message = new $root.protobufs.HttpApiQueue();
            while (reader.pos < end) {
                var tag = reader.uint32();
                switch (tag >>> 3) {
                case 1:
                    if (!(message.queue && message.queue.length))
                        message.queue = [];
                    message.queue.push($root.protobufs.HttpApiQueueItem.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a HttpApiQueue message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {protobufs.HttpApiQueue} HttpApiQueue
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        HttpApiQueue.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a HttpApiQueue message.
         * @function verify
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        HttpApiQueue.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.queue != null && message.hasOwnProperty("queue")) {
                if (!Array.isArray(message.queue))
                    return "queue: array expected";
                for (var i = 0; i < message.queue.length; ++i) {
                    var error = $root.protobufs.HttpApiQueueItem.verify(message.queue[i]);
                    if (error)
                        return "queue." + error;
                }
            }
            return null;
        };

        /**
         * Creates a HttpApiQueue message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {protobufs.HttpApiQueue} HttpApiQueue
         */
        HttpApiQueue.fromObject = function fromObject(object) {
            if (object instanceof $root.protobufs.HttpApiQueue)
                return object;
            var message = new $root.protobufs.HttpApiQueue();
            if (object.queue) {
                if (!Array.isArray(object.queue))
                    throw TypeError(".protobufs.HttpApiQueue.queue: array expected");
                message.queue = [];
                for (var i = 0; i < object.queue.length; ++i) {
                    if (typeof object.queue[i] !== "object")
                        throw TypeError(".protobufs.HttpApiQueue.queue: object expected");
                    message.queue[i] = $root.protobufs.HttpApiQueueItem.fromObject(object.queue[i]);
                }
            }
            return message;
        };

        /**
         * Creates a plain object from a HttpApiQueue message. Also converts values to other types if specified.
         * @function toObject
         * @memberof protobufs.HttpApiQueue
         * @static
         * @param {protobufs.HttpApiQueue} message HttpApiQueue
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        HttpApiQueue.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            var object = {};
            if (options.arrays || options.defaults)
                object.queue = [];
            if (message.queue && message.queue.length) {
                object.queue = [];
                for (var j = 0; j < message.queue.length; ++j)
                    object.queue[j] = $root.protobufs.HttpApiQueueItem.toObject(message.queue[j], options);
            }
            return object;
        };

        /**
         * Converts this HttpApiQueue to JSON.
         * @function toJSON
         * @memberof protobufs.HttpApiQueue
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        HttpApiQueue.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        return HttpApiQueue;
    })();

    protobufs.HttpApiQueueItem = (function() {

        /**
         * Properties of a HttpApiQueueItem.
         * @memberof protobufs
         * @interface IHttpApiQueueItem
         * @property {protobufs.HttpApiQueueItem.HttpApiQueueItemType|null} [type] HttpApiQueueItem type
         * @property {Object.<string,string>|null} [params] HttpApiQueueItem params
         */

        /**
         * Constructs a new HttpApiQueueItem.
         * @memberof protobufs
         * @classdesc Represents a HttpApiQueueItem.
         * @implements IHttpApiQueueItem
         * @constructor
         * @param {protobufs.IHttpApiQueueItem=} [properties] Properties to set
         */
        function HttpApiQueueItem(properties) {
            this.params = {};
            if (properties)
                for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * HttpApiQueueItem type.
         * @member {protobufs.HttpApiQueueItem.HttpApiQueueItemType} type
         * @memberof protobufs.HttpApiQueueItem
         * @instance
         */
        HttpApiQueueItem.prototype.type = 0;

        /**
         * HttpApiQueueItem params.
         * @member {Object.<string,string>} params
         * @memberof protobufs.HttpApiQueueItem
         * @instance
         */
        HttpApiQueueItem.prototype.params = $util.emptyObject;

        /**
         * Creates a new HttpApiQueueItem instance using the specified properties.
         * @function create
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {protobufs.IHttpApiQueueItem=} [properties] Properties to set
         * @returns {protobufs.HttpApiQueueItem} HttpApiQueueItem instance
         */
        HttpApiQueueItem.create = function create(properties) {
            return new HttpApiQueueItem(properties);
        };

        /**
         * Encodes the specified HttpApiQueueItem message. Does not implicitly {@link protobufs.HttpApiQueueItem.verify|verify} messages.
         * @function encode
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {protobufs.IHttpApiQueueItem} message HttpApiQueueItem message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        HttpApiQueueItem.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.type != null && message.hasOwnProperty("type"))
                writer.uint32(/* id 1, wireType 0 =*/8).int32(message.type);
            if (message.params != null && message.hasOwnProperty("params"))
                for (var keys = Object.keys(message.params), i = 0; i < keys.length; ++i)
                    writer.uint32(/* id 2, wireType 2 =*/18).fork().uint32(/* id 1, wireType 2 =*/10).string(keys[i]).uint32(/* id 2, wireType 2 =*/18).string(message.params[keys[i]]).ldelim();
            return writer;
        };

        /**
         * Encodes the specified HttpApiQueueItem message, length delimited. Does not implicitly {@link protobufs.HttpApiQueueItem.verify|verify} messages.
         * @function encodeDelimited
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {protobufs.IHttpApiQueueItem} message HttpApiQueueItem message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        HttpApiQueueItem.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a HttpApiQueueItem message from the specified reader or buffer.
         * @function decode
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {protobufs.HttpApiQueueItem} HttpApiQueueItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        HttpApiQueueItem.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            var end = length === undefined ? reader.len : reader.pos + length, message = new $root.protobufs.HttpApiQueueItem(), key;
            while (reader.pos < end) {
                var tag = reader.uint32();
                switch (tag >>> 3) {
                case 1:
                    message.type = reader.int32();
                    break;
                case 2:
                    reader.skip().pos++;
                    if (message.params === $util.emptyObject)
                        message.params = {};
                    key = reader.string();
                    reader.pos++;
                    message.params[key] = reader.string();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a HttpApiQueueItem message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {protobufs.HttpApiQueueItem} HttpApiQueueItem
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        HttpApiQueueItem.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a HttpApiQueueItem message.
         * @function verify
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        HttpApiQueueItem.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.type != null && message.hasOwnProperty("type"))
                switch (message.type) {
                default:
                    return "type: enum value expected";
                case 0:
                case 1:
                case 2:
                    break;
                }
            if (message.params != null && message.hasOwnProperty("params")) {
                if (!$util.isObject(message.params))
                    return "params: object expected";
                var key = Object.keys(message.params);
                for (var i = 0; i < key.length; ++i)
                    if (!$util.isString(message.params[key[i]]))
                        return "params: string{k:string} expected";
            }
            return null;
        };

        /**
         * Creates a HttpApiQueueItem message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {protobufs.HttpApiQueueItem} HttpApiQueueItem
         */
        HttpApiQueueItem.fromObject = function fromObject(object) {
            if (object instanceof $root.protobufs.HttpApiQueueItem)
                return object;
            var message = new $root.protobufs.HttpApiQueueItem();
            switch (object.type) {
            case "NEW_JOURNAL":
            case 0:
                message.type = 0;
                break;
            case "SAVE_JOURNAL":
            case 1:
                message.type = 1;
                break;
            case "DELETE_JOURNAL":
            case 2:
                message.type = 2;
                break;
            }
            if (object.params) {
                if (typeof object.params !== "object")
                    throw TypeError(".protobufs.HttpApiQueueItem.params: object expected");
                message.params = {};
                for (var keys = Object.keys(object.params), i = 0; i < keys.length; ++i)
                    message.params[keys[i]] = String(object.params[keys[i]]);
            }
            return message;
        };

        /**
         * Creates a plain object from a HttpApiQueueItem message. Also converts values to other types if specified.
         * @function toObject
         * @memberof protobufs.HttpApiQueueItem
         * @static
         * @param {protobufs.HttpApiQueueItem} message HttpApiQueueItem
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        HttpApiQueueItem.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            var object = {};
            if (options.objects || options.defaults)
                object.params = {};
            if (options.defaults)
                object.type = options.enums === String ? "NEW_JOURNAL" : 0;
            if (message.type != null && message.hasOwnProperty("type"))
                object.type = options.enums === String ? $root.protobufs.HttpApiQueueItem.HttpApiQueueItemType[message.type] : message.type;
            var keys2;
            if (message.params && (keys2 = Object.keys(message.params)).length) {
                object.params = {};
                for (var j = 0; j < keys2.length; ++j)
                    object.params[keys2[j]] = message.params[keys2[j]];
            }
            return object;
        };

        /**
         * Converts this HttpApiQueueItem to JSON.
         * @function toJSON
         * @memberof protobufs.HttpApiQueueItem
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        HttpApiQueueItem.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * HttpApiQueueItemType enum.
         * @name protobufs.HttpApiQueueItem.HttpApiQueueItemType
         * @enum {string}
         * @property {number} NEW_JOURNAL=0 NEW_JOURNAL value
         * @property {number} SAVE_JOURNAL=1 SAVE_JOURNAL value
         * @property {number} DELETE_JOURNAL=2 DELETE_JOURNAL value
         */
        HttpApiQueueItem.HttpApiQueueItemType = (function() {
            var valuesById = {}, values = Object.create(valuesById);
            values[valuesById[0] = "NEW_JOURNAL"] = 0;
            values[valuesById[1] = "SAVE_JOURNAL"] = 1;
            values[valuesById[2] = "DELETE_JOURNAL"] = 2;
            return values;
        })();

        return HttpApiQueueItem;
    })();

    protobufs.Journal = (function() {

        /**
         * Properties of a Journal.
         * @memberof protobufs
         * @interface IJournal
         * @property {number|Long|null} [id] Journal id
         * @property {number|Long|null} [userId] Journal userId
         * @property {protobufs.Journal.JournalSaveType|null} [saveType] Journal saveType
         * @property {string|null} [content] Journal content
         * @property {number|Long|null} [createdAt] Journal createdAt
         * @property {number|Long|null} [updatedAt] Journal updatedAt
         */

        /**
         * Constructs a new Journal.
         * @memberof protobufs
         * @classdesc Represents a Journal.
         * @implements IJournal
         * @constructor
         * @param {protobufs.IJournal=} [properties] Properties to set
         */
        function Journal(properties) {
            if (properties)
                for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * Journal id.
         * @member {number|Long} id
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.id = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * Journal userId.
         * @member {number|Long} userId
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.userId = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * Journal saveType.
         * @member {protobufs.Journal.JournalSaveType} saveType
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.saveType = 0;

        /**
         * Journal content.
         * @member {string} content
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.content = "";

        /**
         * Journal createdAt.
         * @member {number|Long} createdAt
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.createdAt = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * Journal updatedAt.
         * @member {number|Long} updatedAt
         * @memberof protobufs.Journal
         * @instance
         */
        Journal.prototype.updatedAt = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * Creates a new Journal instance using the specified properties.
         * @function create
         * @memberof protobufs.Journal
         * @static
         * @param {protobufs.IJournal=} [properties] Properties to set
         * @returns {protobufs.Journal} Journal instance
         */
        Journal.create = function create(properties) {
            return new Journal(properties);
        };

        /**
         * Encodes the specified Journal message. Does not implicitly {@link protobufs.Journal.verify|verify} messages.
         * @function encode
         * @memberof protobufs.Journal
         * @static
         * @param {protobufs.IJournal} message Journal message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        Journal.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.id != null && message.hasOwnProperty("id"))
                writer.uint32(/* id 1, wireType 0 =*/8).int64(message.id);
            if (message.userId != null && message.hasOwnProperty("userId"))
                writer.uint32(/* id 2, wireType 0 =*/16).int64(message.userId);
            if (message.saveType != null && message.hasOwnProperty("saveType"))
                writer.uint32(/* id 3, wireType 0 =*/24).int32(message.saveType);
            if (message.content != null && message.hasOwnProperty("content"))
                writer.uint32(/* id 4, wireType 2 =*/34).string(message.content);
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                writer.uint32(/* id 5, wireType 0 =*/40).int64(message.createdAt);
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                writer.uint32(/* id 6, wireType 0 =*/48).int64(message.updatedAt);
            return writer;
        };

        /**
         * Encodes the specified Journal message, length delimited. Does not implicitly {@link protobufs.Journal.verify|verify} messages.
         * @function encodeDelimited
         * @memberof protobufs.Journal
         * @static
         * @param {protobufs.IJournal} message Journal message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        Journal.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a Journal message from the specified reader or buffer.
         * @function decode
         * @memberof protobufs.Journal
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {protobufs.Journal} Journal
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        Journal.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            var end = length === undefined ? reader.len : reader.pos + length, message = new $root.protobufs.Journal();
            while (reader.pos < end) {
                var tag = reader.uint32();
                switch (tag >>> 3) {
                case 1:
                    message.id = reader.int64();
                    break;
                case 2:
                    message.userId = reader.int64();
                    break;
                case 3:
                    message.saveType = reader.int32();
                    break;
                case 4:
                    message.content = reader.string();
                    break;
                case 5:
                    message.createdAt = reader.int64();
                    break;
                case 6:
                    message.updatedAt = reader.int64();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a Journal message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof protobufs.Journal
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {protobufs.Journal} Journal
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        Journal.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a Journal message.
         * @function verify
         * @memberof protobufs.Journal
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        Journal.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.id != null && message.hasOwnProperty("id"))
                if (!$util.isInteger(message.id) && !(message.id && $util.isInteger(message.id.low) && $util.isInteger(message.id.high)))
                    return "id: integer|Long expected";
            if (message.userId != null && message.hasOwnProperty("userId"))
                if (!$util.isInteger(message.userId) && !(message.userId && $util.isInteger(message.userId.low) && $util.isInteger(message.userId.high)))
                    return "userId: integer|Long expected";
            if (message.saveType != null && message.hasOwnProperty("saveType"))
                switch (message.saveType) {
                default:
                    return "saveType: enum value expected";
                case 0:
                case 1:
                case 2:
                    break;
                }
            if (message.content != null && message.hasOwnProperty("content"))
                if (!$util.isString(message.content))
                    return "content: string expected";
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                if (!$util.isInteger(message.createdAt) && !(message.createdAt && $util.isInteger(message.createdAt.low) && $util.isInteger(message.createdAt.high)))
                    return "createdAt: integer|Long expected";
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                if (!$util.isInteger(message.updatedAt) && !(message.updatedAt && $util.isInteger(message.updatedAt.low) && $util.isInteger(message.updatedAt.high)))
                    return "updatedAt: integer|Long expected";
            return null;
        };

        /**
         * Creates a Journal message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof protobufs.Journal
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {protobufs.Journal} Journal
         */
        Journal.fromObject = function fromObject(object) {
            if (object instanceof $root.protobufs.Journal)
                return object;
            var message = new $root.protobufs.Journal();
            if (object.id != null)
                if ($util.Long)
                    (message.id = $util.Long.fromValue(object.id)).unsigned = false;
                else if (typeof object.id === "string")
                    message.id = parseInt(object.id, 10);
                else if (typeof object.id === "number")
                    message.id = object.id;
                else if (typeof object.id === "object")
                    message.id = new $util.LongBits(object.id.low >>> 0, object.id.high >>> 0).toNumber();
            if (object.userId != null)
                if ($util.Long)
                    (message.userId = $util.Long.fromValue(object.userId)).unsigned = false;
                else if (typeof object.userId === "string")
                    message.userId = parseInt(object.userId, 10);
                else if (typeof object.userId === "number")
                    message.userId = object.userId;
                else if (typeof object.userId === "object")
                    message.userId = new $util.LongBits(object.userId.low >>> 0, object.userId.high >>> 0).toNumber();
            switch (object.saveType) {
            case "LOCAL":
            case 0:
                message.saveType = 0;
                break;
            case "PLAINTEXT":
            case 1:
                message.saveType = 1;
                break;
            case "ENCRYPTED":
            case 2:
                message.saveType = 2;
                break;
            }
            if (object.content != null)
                message.content = String(object.content);
            if (object.createdAt != null)
                if ($util.Long)
                    (message.createdAt = $util.Long.fromValue(object.createdAt)).unsigned = false;
                else if (typeof object.createdAt === "string")
                    message.createdAt = parseInt(object.createdAt, 10);
                else if (typeof object.createdAt === "number")
                    message.createdAt = object.createdAt;
                else if (typeof object.createdAt === "object")
                    message.createdAt = new $util.LongBits(object.createdAt.low >>> 0, object.createdAt.high >>> 0).toNumber();
            if (object.updatedAt != null)
                if ($util.Long)
                    (message.updatedAt = $util.Long.fromValue(object.updatedAt)).unsigned = false;
                else if (typeof object.updatedAt === "string")
                    message.updatedAt = parseInt(object.updatedAt, 10);
                else if (typeof object.updatedAt === "number")
                    message.updatedAt = object.updatedAt;
                else if (typeof object.updatedAt === "object")
                    message.updatedAt = new $util.LongBits(object.updatedAt.low >>> 0, object.updatedAt.high >>> 0).toNumber();
            return message;
        };

        /**
         * Creates a plain object from a Journal message. Also converts values to other types if specified.
         * @function toObject
         * @memberof protobufs.Journal
         * @static
         * @param {protobufs.Journal} message Journal
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        Journal.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            var object = {};
            if (options.defaults) {
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.id = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.id = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.userId = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.userId = options.longs === String ? "0" : 0;
                object.saveType = options.enums === String ? "LOCAL" : 0;
                object.content = "";
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.createdAt = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.createdAt = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.updatedAt = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.updatedAt = options.longs === String ? "0" : 0;
            }
            if (message.id != null && message.hasOwnProperty("id"))
                if (typeof message.id === "number")
                    object.id = options.longs === String ? String(message.id) : message.id;
                else
                    object.id = options.longs === String ? $util.Long.prototype.toString.call(message.id) : options.longs === Number ? new $util.LongBits(message.id.low >>> 0, message.id.high >>> 0).toNumber() : message.id;
            if (message.userId != null && message.hasOwnProperty("userId"))
                if (typeof message.userId === "number")
                    object.userId = options.longs === String ? String(message.userId) : message.userId;
                else
                    object.userId = options.longs === String ? $util.Long.prototype.toString.call(message.userId) : options.longs === Number ? new $util.LongBits(message.userId.low >>> 0, message.userId.high >>> 0).toNumber() : message.userId;
            if (message.saveType != null && message.hasOwnProperty("saveType"))
                object.saveType = options.enums === String ? $root.protobufs.Journal.JournalSaveType[message.saveType] : message.saveType;
            if (message.content != null && message.hasOwnProperty("content"))
                object.content = message.content;
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                if (typeof message.createdAt === "number")
                    object.createdAt = options.longs === String ? String(message.createdAt) : message.createdAt;
                else
                    object.createdAt = options.longs === String ? $util.Long.prototype.toString.call(message.createdAt) : options.longs === Number ? new $util.LongBits(message.createdAt.low >>> 0, message.createdAt.high >>> 0).toNumber() : message.createdAt;
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                if (typeof message.updatedAt === "number")
                    object.updatedAt = options.longs === String ? String(message.updatedAt) : message.updatedAt;
                else
                    object.updatedAt = options.longs === String ? $util.Long.prototype.toString.call(message.updatedAt) : options.longs === Number ? new $util.LongBits(message.updatedAt.low >>> 0, message.updatedAt.high >>> 0).toNumber() : message.updatedAt;
            return object;
        };

        /**
         * Converts this Journal to JSON.
         * @function toJSON
         * @memberof protobufs.Journal
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        Journal.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * JournalSaveType enum.
         * @name protobufs.Journal.JournalSaveType
         * @enum {string}
         * @property {number} LOCAL=0 LOCAL value
         * @property {number} PLAINTEXT=1 PLAINTEXT value
         * @property {number} ENCRYPTED=2 ENCRYPTED value
         */
        Journal.JournalSaveType = (function() {
            var valuesById = {}, values = Object.create(valuesById);
            values[valuesById[0] = "LOCAL"] = 0;
            values[valuesById[1] = "PLAINTEXT"] = 1;
            values[valuesById[2] = "ENCRYPTED"] = 2;
            return values;
        })();

        return Journal;
    })();

    protobufs.JournalResponse = (function() {

        /**
         * Properties of a JournalResponse.
         * @memberof protobufs
         * @interface IJournalResponse
         * @property {number|Long|null} [total] JournalResponse total
         * @property {number|Long|null} [size] JournalResponse size
         * @property {Array.<protobufs.IJournal>|null} [journals] JournalResponse journals
         */

        /**
         * Constructs a new JournalResponse.
         * @memberof protobufs
         * @classdesc Represents a JournalResponse.
         * @implements IJournalResponse
         * @constructor
         * @param {protobufs.IJournalResponse=} [properties] Properties to set
         */
        function JournalResponse(properties) {
            this.journals = [];
            if (properties)
                for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * JournalResponse total.
         * @member {number|Long} total
         * @memberof protobufs.JournalResponse
         * @instance
         */
        JournalResponse.prototype.total = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * JournalResponse size.
         * @member {number|Long} size
         * @memberof protobufs.JournalResponse
         * @instance
         */
        JournalResponse.prototype.size = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * JournalResponse journals.
         * @member {Array.<protobufs.IJournal>} journals
         * @memberof protobufs.JournalResponse
         * @instance
         */
        JournalResponse.prototype.journals = $util.emptyArray;

        /**
         * Creates a new JournalResponse instance using the specified properties.
         * @function create
         * @memberof protobufs.JournalResponse
         * @static
         * @param {protobufs.IJournalResponse=} [properties] Properties to set
         * @returns {protobufs.JournalResponse} JournalResponse instance
         */
        JournalResponse.create = function create(properties) {
            return new JournalResponse(properties);
        };

        /**
         * Encodes the specified JournalResponse message. Does not implicitly {@link protobufs.JournalResponse.verify|verify} messages.
         * @function encode
         * @memberof protobufs.JournalResponse
         * @static
         * @param {protobufs.IJournalResponse} message JournalResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        JournalResponse.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.total != null && message.hasOwnProperty("total"))
                writer.uint32(/* id 1, wireType 0 =*/8).int64(message.total);
            if (message.size != null && message.hasOwnProperty("size"))
                writer.uint32(/* id 2, wireType 0 =*/16).int64(message.size);
            if (message.journals != null && message.journals.length)
                for (var i = 0; i < message.journals.length; ++i)
                    $root.protobufs.Journal.encode(message.journals[i], writer.uint32(/* id 3, wireType 2 =*/26).fork()).ldelim();
            return writer;
        };

        /**
         * Encodes the specified JournalResponse message, length delimited. Does not implicitly {@link protobufs.JournalResponse.verify|verify} messages.
         * @function encodeDelimited
         * @memberof protobufs.JournalResponse
         * @static
         * @param {protobufs.IJournalResponse} message JournalResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        JournalResponse.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a JournalResponse message from the specified reader or buffer.
         * @function decode
         * @memberof protobufs.JournalResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {protobufs.JournalResponse} JournalResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        JournalResponse.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            var end = length === undefined ? reader.len : reader.pos + length, message = new $root.protobufs.JournalResponse();
            while (reader.pos < end) {
                var tag = reader.uint32();
                switch (tag >>> 3) {
                case 1:
                    message.total = reader.int64();
                    break;
                case 2:
                    message.size = reader.int64();
                    break;
                case 3:
                    if (!(message.journals && message.journals.length))
                        message.journals = [];
                    message.journals.push($root.protobufs.Journal.decode(reader, reader.uint32()));
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a JournalResponse message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof protobufs.JournalResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {protobufs.JournalResponse} JournalResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        JournalResponse.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a JournalResponse message.
         * @function verify
         * @memberof protobufs.JournalResponse
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        JournalResponse.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.total != null && message.hasOwnProperty("total"))
                if (!$util.isInteger(message.total) && !(message.total && $util.isInteger(message.total.low) && $util.isInteger(message.total.high)))
                    return "total: integer|Long expected";
            if (message.size != null && message.hasOwnProperty("size"))
                if (!$util.isInteger(message.size) && !(message.size && $util.isInteger(message.size.low) && $util.isInteger(message.size.high)))
                    return "size: integer|Long expected";
            if (message.journals != null && message.hasOwnProperty("journals")) {
                if (!Array.isArray(message.journals))
                    return "journals: array expected";
                for (var i = 0; i < message.journals.length; ++i) {
                    var error = $root.protobufs.Journal.verify(message.journals[i]);
                    if (error)
                        return "journals." + error;
                }
            }
            return null;
        };

        /**
         * Creates a JournalResponse message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof protobufs.JournalResponse
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {protobufs.JournalResponse} JournalResponse
         */
        JournalResponse.fromObject = function fromObject(object) {
            if (object instanceof $root.protobufs.JournalResponse)
                return object;
            var message = new $root.protobufs.JournalResponse();
            if (object.total != null)
                if ($util.Long)
                    (message.total = $util.Long.fromValue(object.total)).unsigned = false;
                else if (typeof object.total === "string")
                    message.total = parseInt(object.total, 10);
                else if (typeof object.total === "number")
                    message.total = object.total;
                else if (typeof object.total === "object")
                    message.total = new $util.LongBits(object.total.low >>> 0, object.total.high >>> 0).toNumber();
            if (object.size != null)
                if ($util.Long)
                    (message.size = $util.Long.fromValue(object.size)).unsigned = false;
                else if (typeof object.size === "string")
                    message.size = parseInt(object.size, 10);
                else if (typeof object.size === "number")
                    message.size = object.size;
                else if (typeof object.size === "object")
                    message.size = new $util.LongBits(object.size.low >>> 0, object.size.high >>> 0).toNumber();
            if (object.journals) {
                if (!Array.isArray(object.journals))
                    throw TypeError(".protobufs.JournalResponse.journals: array expected");
                message.journals = [];
                for (var i = 0; i < object.journals.length; ++i) {
                    if (typeof object.journals[i] !== "object")
                        throw TypeError(".protobufs.JournalResponse.journals: object expected");
                    message.journals[i] = $root.protobufs.Journal.fromObject(object.journals[i]);
                }
            }
            return message;
        };

        /**
         * Creates a plain object from a JournalResponse message. Also converts values to other types if specified.
         * @function toObject
         * @memberof protobufs.JournalResponse
         * @static
         * @param {protobufs.JournalResponse} message JournalResponse
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        JournalResponse.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            var object = {};
            if (options.arrays || options.defaults)
                object.journals = [];
            if (options.defaults) {
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.total = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.total = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.size = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.size = options.longs === String ? "0" : 0;
            }
            if (message.total != null && message.hasOwnProperty("total"))
                if (typeof message.total === "number")
                    object.total = options.longs === String ? String(message.total) : message.total;
                else
                    object.total = options.longs === String ? $util.Long.prototype.toString.call(message.total) : options.longs === Number ? new $util.LongBits(message.total.low >>> 0, message.total.high >>> 0).toNumber() : message.total;
            if (message.size != null && message.hasOwnProperty("size"))
                if (typeof message.size === "number")
                    object.size = options.longs === String ? String(message.size) : message.size;
                else
                    object.size = options.longs === String ? $util.Long.prototype.toString.call(message.size) : options.longs === Number ? new $util.LongBits(message.size.low >>> 0, message.size.high >>> 0).toNumber() : message.size;
            if (message.journals && message.journals.length) {
                object.journals = [];
                for (var j = 0; j < message.journals.length; ++j)
                    object.journals[j] = $root.protobufs.Journal.toObject(message.journals[j], options);
            }
            return object;
        };

        /**
         * Converts this JournalResponse to JSON.
         * @function toJSON
         * @memberof protobufs.JournalResponse
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        JournalResponse.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        return JournalResponse;
    })();

    protobufs.User = (function() {

        /**
         * Properties of a User.
         * @memberof protobufs
         * @interface IUser
         * @property {number|Long|null} [id] User id
         * @property {string|null} [email] User email
         * @property {string|null} [firstName] User firstName
         * @property {string|null} [lastName] User lastName
         * @property {number|Long|null} [createdAt] User createdAt
         * @property {number|Long|null} [updatedAt] User updatedAt
         */

        /**
         * Constructs a new User.
         * @memberof protobufs
         * @classdesc Represents a User.
         * @implements IUser
         * @constructor
         * @param {protobufs.IUser=} [properties] Properties to set
         */
        function User(properties) {
            if (properties)
                for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * User id.
         * @member {number|Long} id
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.id = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * User email.
         * @member {string} email
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.email = "";

        /**
         * User firstName.
         * @member {string} firstName
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.firstName = "";

        /**
         * User lastName.
         * @member {string} lastName
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.lastName = "";

        /**
         * User createdAt.
         * @member {number|Long} createdAt
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.createdAt = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * User updatedAt.
         * @member {number|Long} updatedAt
         * @memberof protobufs.User
         * @instance
         */
        User.prototype.updatedAt = $util.Long ? $util.Long.fromBits(0,0,false) : 0;

        /**
         * Creates a new User instance using the specified properties.
         * @function create
         * @memberof protobufs.User
         * @static
         * @param {protobufs.IUser=} [properties] Properties to set
         * @returns {protobufs.User} User instance
         */
        User.create = function create(properties) {
            return new User(properties);
        };

        /**
         * Encodes the specified User message. Does not implicitly {@link protobufs.User.verify|verify} messages.
         * @function encode
         * @memberof protobufs.User
         * @static
         * @param {protobufs.IUser} message User message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        User.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.id != null && message.hasOwnProperty("id"))
                writer.uint32(/* id 1, wireType 0 =*/8).int64(message.id);
            if (message.email != null && message.hasOwnProperty("email"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.email);
            if (message.firstName != null && message.hasOwnProperty("firstName"))
                writer.uint32(/* id 3, wireType 2 =*/26).string(message.firstName);
            if (message.lastName != null && message.hasOwnProperty("lastName"))
                writer.uint32(/* id 4, wireType 2 =*/34).string(message.lastName);
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                writer.uint32(/* id 5, wireType 0 =*/40).int64(message.createdAt);
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                writer.uint32(/* id 6, wireType 0 =*/48).int64(message.updatedAt);
            return writer;
        };

        /**
         * Encodes the specified User message, length delimited. Does not implicitly {@link protobufs.User.verify|verify} messages.
         * @function encodeDelimited
         * @memberof protobufs.User
         * @static
         * @param {protobufs.IUser} message User message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        User.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a User message from the specified reader or buffer.
         * @function decode
         * @memberof protobufs.User
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {protobufs.User} User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        User.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            var end = length === undefined ? reader.len : reader.pos + length, message = new $root.protobufs.User();
            while (reader.pos < end) {
                var tag = reader.uint32();
                switch (tag >>> 3) {
                case 1:
                    message.id = reader.int64();
                    break;
                case 2:
                    message.email = reader.string();
                    break;
                case 3:
                    message.firstName = reader.string();
                    break;
                case 4:
                    message.lastName = reader.string();
                    break;
                case 5:
                    message.createdAt = reader.int64();
                    break;
                case 6:
                    message.updatedAt = reader.int64();
                    break;
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a User message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof protobufs.User
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {protobufs.User} User
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        User.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a User message.
         * @function verify
         * @memberof protobufs.User
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        User.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.id != null && message.hasOwnProperty("id"))
                if (!$util.isInteger(message.id) && !(message.id && $util.isInteger(message.id.low) && $util.isInteger(message.id.high)))
                    return "id: integer|Long expected";
            if (message.email != null && message.hasOwnProperty("email"))
                if (!$util.isString(message.email))
                    return "email: string expected";
            if (message.firstName != null && message.hasOwnProperty("firstName"))
                if (!$util.isString(message.firstName))
                    return "firstName: string expected";
            if (message.lastName != null && message.hasOwnProperty("lastName"))
                if (!$util.isString(message.lastName))
                    return "lastName: string expected";
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                if (!$util.isInteger(message.createdAt) && !(message.createdAt && $util.isInteger(message.createdAt.low) && $util.isInteger(message.createdAt.high)))
                    return "createdAt: integer|Long expected";
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                if (!$util.isInteger(message.updatedAt) && !(message.updatedAt && $util.isInteger(message.updatedAt.low) && $util.isInteger(message.updatedAt.high)))
                    return "updatedAt: integer|Long expected";
            return null;
        };

        /**
         * Creates a User message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof protobufs.User
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {protobufs.User} User
         */
        User.fromObject = function fromObject(object) {
            if (object instanceof $root.protobufs.User)
                return object;
            var message = new $root.protobufs.User();
            if (object.id != null)
                if ($util.Long)
                    (message.id = $util.Long.fromValue(object.id)).unsigned = false;
                else if (typeof object.id === "string")
                    message.id = parseInt(object.id, 10);
                else if (typeof object.id === "number")
                    message.id = object.id;
                else if (typeof object.id === "object")
                    message.id = new $util.LongBits(object.id.low >>> 0, object.id.high >>> 0).toNumber();
            if (object.email != null)
                message.email = String(object.email);
            if (object.firstName != null)
                message.firstName = String(object.firstName);
            if (object.lastName != null)
                message.lastName = String(object.lastName);
            if (object.createdAt != null)
                if ($util.Long)
                    (message.createdAt = $util.Long.fromValue(object.createdAt)).unsigned = false;
                else if (typeof object.createdAt === "string")
                    message.createdAt = parseInt(object.createdAt, 10);
                else if (typeof object.createdAt === "number")
                    message.createdAt = object.createdAt;
                else if (typeof object.createdAt === "object")
                    message.createdAt = new $util.LongBits(object.createdAt.low >>> 0, object.createdAt.high >>> 0).toNumber();
            if (object.updatedAt != null)
                if ($util.Long)
                    (message.updatedAt = $util.Long.fromValue(object.updatedAt)).unsigned = false;
                else if (typeof object.updatedAt === "string")
                    message.updatedAt = parseInt(object.updatedAt, 10);
                else if (typeof object.updatedAt === "number")
                    message.updatedAt = object.updatedAt;
                else if (typeof object.updatedAt === "object")
                    message.updatedAt = new $util.LongBits(object.updatedAt.low >>> 0, object.updatedAt.high >>> 0).toNumber();
            return message;
        };

        /**
         * Creates a plain object from a User message. Also converts values to other types if specified.
         * @function toObject
         * @memberof protobufs.User
         * @static
         * @param {protobufs.User} message User
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        User.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            var object = {};
            if (options.defaults) {
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.id = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.id = options.longs === String ? "0" : 0;
                object.email = "";
                object.firstName = "";
                object.lastName = "";
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.createdAt = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.createdAt = options.longs === String ? "0" : 0;
                if ($util.Long) {
                    var long = new $util.Long(0, 0, false);
                    object.updatedAt = options.longs === String ? long.toString() : options.longs === Number ? long.toNumber() : long;
                } else
                    object.updatedAt = options.longs === String ? "0" : 0;
            }
            if (message.id != null && message.hasOwnProperty("id"))
                if (typeof message.id === "number")
                    object.id = options.longs === String ? String(message.id) : message.id;
                else
                    object.id = options.longs === String ? $util.Long.prototype.toString.call(message.id) : options.longs === Number ? new $util.LongBits(message.id.low >>> 0, message.id.high >>> 0).toNumber() : message.id;
            if (message.email != null && message.hasOwnProperty("email"))
                object.email = message.email;
            if (message.firstName != null && message.hasOwnProperty("firstName"))
                object.firstName = message.firstName;
            if (message.lastName != null && message.hasOwnProperty("lastName"))
                object.lastName = message.lastName;
            if (message.createdAt != null && message.hasOwnProperty("createdAt"))
                if (typeof message.createdAt === "number")
                    object.createdAt = options.longs === String ? String(message.createdAt) : message.createdAt;
                else
                    object.createdAt = options.longs === String ? $util.Long.prototype.toString.call(message.createdAt) : options.longs === Number ? new $util.LongBits(message.createdAt.low >>> 0, message.createdAt.high >>> 0).toNumber() : message.createdAt;
            if (message.updatedAt != null && message.hasOwnProperty("updatedAt"))
                if (typeof message.updatedAt === "number")
                    object.updatedAt = options.longs === String ? String(message.updatedAt) : message.updatedAt;
                else
                    object.updatedAt = options.longs === String ? $util.Long.prototype.toString.call(message.updatedAt) : options.longs === Number ? new $util.LongBits(message.updatedAt.low >>> 0, message.updatedAt.high >>> 0).toNumber() : message.updatedAt;
            return object;
        };

        /**
         * Converts this User to JSON.
         * @function toJSON
         * @memberof protobufs.User
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        User.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        return User;
    })();

    return protobufs;
})();

module.exports = $root;
