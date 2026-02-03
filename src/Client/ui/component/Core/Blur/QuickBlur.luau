--!native
--!optimize 2

-- https://devforum.roblox.com/t/editableimage-image-blur-module/2828242

local QuickBlur = {} :: QuickBlurImpl
local AssetService = game:GetService("AssetService")
type QuickBlurImpl = {
	Blur: (self: QuickBlurImpl, SrcImage: EditableImage, Size: number?, Desample: number?) -> EditableImage,
}

local function u8(b: buffer, offset: number, max: number, alt_num: number): number
	if offset < 0 then return alt_num end
	if offset >= max then return alt_num end
	return buffer.readu8(b, offset)
end
function QuickBlur:Blur(SrcImage, Size, Desample)
	-- Blur works best when desampled alot, this is the default setting, as a result
	Size = Size or 3
	Desample = Desample or 12

	local ImageWidth = SrcImage.Size.X // Desample
	local ImageHeight = SrcImage.Size.Y // Desample
	local OrginalSize = SrcImage.Size
	local DownsampledSize = Vector2.new(ImageWidth, ImageHeight)

	local TotalRGBA = (ImageWidth * ImageHeight) * 4

	-- Resample image to improve speed
	-- Maybe that's cheating but whateverr

	local Image = AssetService:CreateEditableImage({
		Size = DownsampledSize,
	})

	Image:DrawImageTransformed(
		Vector2.zero,
		Vector2.new(ImageWidth / OrginalSize.X, ImageHeight / OrginalSize.Y),
		0,
		SrcImage,
		{
			SamplingMode = Enum.ResamplerMode.Default,
			PivotPoint = Vector2.zero,
		}
	)

	local ImageData = Image:ReadPixelsBuffer(Vector2.zero, DownsampledSize)
	local buffer_index
	local top_left_index
	local top_right_index
	local low_left_index
	local low_right_index
	local top_left
	local top_right
	local low_left
	local low_right
	local top_centre
	local low_centre
	local mid_left
	local mid_right
	local pixel
	local default

	for pass = 1, Size do
		for y = 0, ImageHeight - 1 do
			for x = 0, ImageWidth - 1 do
				top_left_index = (ImageWidth * 4 * (y + 1) + (x - 1) * 4)
				top_right_index = (ImageWidth * 4 * (y + 1) + (x + 1) * 4)
				low_left_index = (ImageWidth * 4 * (y - 1) + (x - 1) * 4)
				low_right_index = (ImageWidth * 4 * (y - 1) + (x + 1) * 4)
				buffer_index = (ImageWidth * 4 * y + x * 4)

				for offset = 0, 2 do
					pixel = u8(ImageData, buffer_index + offset, TotalRGBA, 0)
					top_left = u8(ImageData, top_left_index + offset, TotalRGBA, pixel)
					top_right = u8(ImageData, top_right_index + offset, TotalRGBA, pixel)
					low_left = u8(ImageData, low_left_index + offset, TotalRGBA, top_left)
					low_right = u8(ImageData, low_right_index + offset, TotalRGBA, top_right)

					top_centre = (top_right + top_left) / 2
					low_centre = (low_right + low_left) / 2
					mid_left = (low_left + top_left) / 2
					mid_right = (low_right + top_right) / 2

					buffer.writeu8(
						ImageData,
						buffer_index + offset,
						(
							top_left
							+ top_right
							+ low_left
							+ low_right
							+ top_centre
							+ low_centre
							+ mid_left
							+ mid_left
							+ pixel
						) / 9
					)
				end
			end
		end
	end

	Image:WritePixelsBuffer(Vector2.zero, DownsampledSize, ImageData)
	-- Previously I resized the image to it's orginal resolution, slowed everything down, so I removed it
	-- Roblox already does bilinear interpolation with ImageLabels
	return Image
end

return QuickBlur
