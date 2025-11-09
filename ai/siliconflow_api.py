import os
from dotenv import load_dotenv
from openai import OpenAI

class SiliconFlowAPI:
    """SiliconFlow API封装，使用OpenAI兼容接口"""

    def __init__(self, api_key=None, model_name=None):
        """
        初始化SiliconFlow API

        Args:
            api_key (str, optional): API密钥，如果为None则从环境变量中读取
            model_name (str, optional): 模型名称，如果为None则使用默认模型
        """
        # 加载环境变量
        load_dotenv()

        # 从环境变量或参数获取API密钥
        self.api_key = api_key or os.getenv('SILICONFLOW_API_KEY')
        if not self.api_key:
            raise ValueError("未提供SiliconFlow API密钥，也未在环境变量中找到SILICONFLOW_API_KEY")

        # 默认模型和配置
        self.model_name = model_name or os.getenv('SILICONFLOW_MODEL', "Qwen/Qwen2.5-72B-Instruct")
        self.temperature = float(os.getenv('SILICONFLOW_TEMPERATURE', '0.7'))  # 默认温度参数
        self.base_url = os.getenv('SILICONFLOW_BASE_URL', "https://api.siliconflow.cn/v1")

        # 初始化OpenAI客户端
        self._configure_siliconflow_api()

    def _configure_siliconflow_api(self):
        """配置SiliconFlow API客户端"""
        # 创建OpenAI客户端实例，使用SiliconFlow的base_url
        self.client = OpenAI(
            api_key=self.api_key,
            base_url=self.base_url
        )

        print(f"已初始化SiliconFlow API客户端，使用模型: {self.model_name}")

    def generate_text(self, prompt):
        """
        使用SiliconFlow API生成文本

        Args:
            prompt (str): 提示词

        Returns:
            str: 生成的文本
        """
        try:
            # 使用OpenAI兼容的API调用方式
            response = self.client.chat.completions.create(
                model=self.model_name,
                messages=[
                    {'role': 'user', 'content': prompt}
                ],
                temperature=self.temperature,
                stream=False  # 不使用流式输出，直接返回完整结果
            )

            # 提取并返回生成的文本
            if response.choices and len(response.choices) > 0:
                content = response.choices[0].message.content
                if content:
                    return content
                else:
                    raise RuntimeError("API响应中没有生成内容")
            else:
                raise RuntimeError("API响应格式异常，无法提取生成的文本")

        except Exception as e:
            raise RuntimeError(f"SiliconFlow API调用失败: {str(e)}")

    def generate_text_stream(self, prompt):
        """
        使用SiliconFlow API生成文本（流式输出）

        Args:
            prompt (str): 提示词

        Yields:
            str: 生成的文本片段
        """
        try:
            # 使用流式输出
            response = self.client.chat.completions.create(
                model=self.model_name,
                messages=[
                    {'role': 'user', 'content': prompt}
                ],
                temperature=self.temperature,
                stream=True
            )

            # 流式返回生成的文本
            for chunk in response:
                if chunk.choices and len(chunk.choices) > 0:
                    delta = chunk.choices[0].delta
                    if hasattr(delta, 'content') and delta.content:
                        yield delta.content

        except Exception as e:
            raise RuntimeError(f"SiliconFlow API流式调用失败: {str(e)}")

